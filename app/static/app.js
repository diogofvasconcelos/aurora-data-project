// Dashboard Controller - Rede Comercial Aurora

// Global state
let charts = {
  faturamentoMensal: null,
  receitaFilial: null,
  receitaCategoria: null
};

let allProducts = [];

const API_BASE = "";

// Chart color palette (professional, muted)
const COLORS = {
  blue:    { main: "#3b82f6", bg: "rgba(59, 130, 246, 0.08)",  hover: "rgba(59, 130, 246, 0.7)" },
  emerald: { main: "#10b981", bg: "rgba(16, 185, 129, 0.08)",  hover: "rgba(16, 185, 129, 0.7)" },
  purple:  { main: "#8b5cf6", bg: "rgba(139, 92, 246, 0.08)",  hover: "rgba(139, 92, 246, 0.7)" },
  rose:    { main: "#f43f5e", bg: "rgba(244, 63, 94, 0.08)",   hover: "rgba(244, 63, 94, 0.7)" },
  amber:   { main: "#f59e0b", bg: "rgba(245, 158, 11, 0.08)",  hover: "rgba(245, 158, 11, 0.7)" },
  sky:     { main: "#0ea5e9", bg: "rgba(14, 165, 233, 0.08)",  hover: "rgba(14, 165, 233, 0.7)" },
  indigo:  { main: "#6366f1", bg: "rgba(99, 102, 241, 0.08)",  hover: "rgba(99, 102, 241, 0.7)" },
  teal:    { main: "#14b8a6", bg: "rgba(20, 184, 166, 0.08)",  hover: "rgba(20, 184, 166, 0.7)" }
};

// Chart theme constants
const GRID_COLOR = "rgba(255, 255, 255, 0.04)";
const TICK_COLOR = "#6b7280";
const LEGEND_COLOR = "#9ca3af";

// Initialize
document.addEventListener("DOMContentLoaded", () => {
  lucide.createIcons();
  initFilters();
  loadDashboardData();
});

// Load filter options
async function initFilters() {
  try {
    const [resFiliais, resCategorias, resProdutos] = await Promise.all([
      fetch(`${API_BASE}/api/filiais`).then(r => r.json()),
      fetch(`${API_BASE}/api/categorias`).then(r => r.json()),
      fetch(`${API_BASE}/api/produtos`).then(r => r.json())
    ]);

    const selectFilial = document.getElementById("filter-filial");
    resFiliais.dados.forEach(filial => {
      const opt = document.createElement("option");
      opt.value = filial.id;
      opt.textContent = filial.nome;
      selectFilial.appendChild(opt);
    });

    const selectCategoria = document.getElementById("filter-categoria");
    resCategorias.dados.forEach(cat => {
      const opt = document.createElement("option");
      opt.value = cat.id;
      opt.textContent = cat.nome;
      selectCategoria.appendChild(opt);
    });

    allProducts = resProdutos.dados;
    populateProductDropdown();

    selectCategoria.addEventListener("change", () => {
      populateProductDropdown(selectCategoria.value);
    });

  } catch (error) {
    console.error("Erro ao carregar filtros:", error);
    setConnectionStatus(false);
    showErrorState(true);
  }
}

function populateProductDropdown(selectedCategoryId = "") {
  const selectProduto = document.getElementById("filter-produto");
  selectProduto.innerHTML = '<option value="">Todos os produtos</option>';
  
  const filtered = selectedCategoryId 
    ? allProducts.filter(p => p.categoria_id == selectedCategoryId)
    : allProducts;
    
  filtered.forEach(p => {
    const opt = document.createElement("option");
    opt.value = p.id;
    opt.textContent = p.nome;
    selectProduto.appendChild(opt);
  });
}

function setPresetRange(preset) {
  const inputStart = document.getElementById("filter-data-inicio");
  const inputEnd = document.getElementById("filter-data-fim");
  
  if (preset === "full") {
    inputStart.value = "";
    inputEnd.value = "";
  } else if (preset === "h1") {
    inputStart.value = "2024-01-01";
    inputEnd.value = "2024-06-30";
  } else if (preset === "h2") {
    inputStart.value = "2024-07-01";
    inputEnd.value = "2024-12-31";
  }
}

function getFilterQueryParams() {
  const start = document.getElementById("filter-data-inicio").value;
  const end = document.getElementById("filter-data-fim").value;
  const filial = document.getElementById("filter-filial").value;
  const categoria = document.getElementById("filter-categoria").value;
  const produto = document.getElementById("filter-produto").value;

  const params = new URLSearchParams();
  if (start) params.append("data_inicio", start);
  if (end) params.append("data_fim", end);
  if (filial) params.append("filial_id", filial);
  if (categoria) params.append("categoria_id", categoria);
  if (produto) params.append("produto_id", produto);

  return params.toString();
}

function applyFilters() {
  loadDashboardData();
}

function clearFilters() {
  document.getElementById("filter-form").reset();
  populateProductDropdown();
  loadDashboardData();
}

// Main data loader
async function loadDashboardData() {
  showLoading(true);
  showErrorState(false);
  
  const queryString = getFilterQueryParams();
  const suffix = queryString ? `?${queryString}` : "";

  try {
    const [resKpis, resMensal, resFilial, resCategoria, resProdutos] = await Promise.all([
      fetch(`${API_BASE}/api/indicadores-gerais${suffix}`).then(r => r.json()),
      fetch(`${API_BASE}/api/faturamento-mensal${suffix}`).then(r => r.json()),
      fetch(`${API_BASE}/api/receita-filial${suffix}`).then(r => r.json()),
      fetch(`${API_BASE}/api/receita-categoria${suffix}`).then(r => r.json()),
      fetch(`${API_BASE}/api/produtos-mais-vendidos${suffix}`).then(r => r.json())
    ]);

    if (resKpis.erro || resMensal.erro || resFilial.erro || resCategoria.erro || resProdutos.erro) {
      throw new Error(resKpis.erro || "Falha na API");
    }

    // Connection OK
    setConnectionStatus(true);

    const alertDiv = document.getElementById("no-data-alert");
    const hasData = resKpis.dados && resKpis.dados.length > 0 && resKpis.dados[0].faturamento_bruto > 0;
    
    if (!hasData) {
      alertDiv.classList.remove("hidden");
    } else {
      alertDiv.classList.add("hidden");
    }

    updateKpiWidgets(resKpis.dados[0] || {});
    renderFaturamentoMensalChart(resMensal.dados || []);
    renderReceitaFilialChart(resFilial.dados || []);
    renderReceitaCategoriaChart(resCategoria.dados || []);
    renderProdutosMaisVendidosTable(resProdutos.dados || []);

  } catch (error) {
    console.error("Erro ao carregar dados:", error);
    setConnectionStatus(false);
    showErrorState(true);
  } finally {
    showLoading(false);
  }
}

// Animated counter
function animateValue(elementId, targetValue, isCurrency = false, isPercentage = false) {
  const obj = document.getElementById(elementId);
  if (!obj) return;

  const startValue = parseFloat(obj.getAttribute("data-val") || "0");
  const duration = 700;
  const startTime = performance.now();

  function updateNumber(now) {
    const elapsed = now - startTime;
    const progress = Math.min(elapsed / duration, 1);
    const easeProgress = 1 - Math.pow(1 - progress, 3);
    const currentValue = startValue + (targetValue - startValue) * easeProgress;
    
    if (isCurrency) {
      obj.textContent = formatCurrency(currentValue);
    } else if (isPercentage) {
      obj.textContent = formatPercentage(currentValue);
    } else {
      obj.textContent = Math.round(currentValue).toLocaleString("pt-BR");
    }

    if (progress < 1) {
      requestAnimationFrame(updateNumber);
    } else {
      obj.setAttribute("data-val", targetValue);
    }
  }

  requestAnimationFrame(updateNumber);
}

function formatCurrency(val) {
  return new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: "BRL"
  }).format(val || 0);
}

function formatPercentage(val) {
  return (val || 0).toLocaleString("pt-BR", {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2
  }) + "%";
}

function updateKpiWidgets(kpis) {
  animateValue("kpi-faturamento-bruto", kpis.faturamento_bruto, true);
  animateValue("kpi-desconto-total", kpis.desconto_total, true);
  animateValue("kpi-receita-liquida", kpis.receita_liquida, true);
  animateValue("kpi-custo-total", kpis.custo_total, true);
  animateValue("kpi-margem-bruta", kpis.margem_bruta, true);
  
  const mPct = kpis.margem_bruta_pct || 0;
  animateValue("kpi-margem-bruta-pct", mPct, false, true);
  
  const pctBar = document.getElementById("kpi-margem-bruta-pct-bar");
  if (pctBar) {
    const clampedPct = Math.max(0, Math.min(100, mPct));
    pctBar.style.transition = "width 0.7s ease";
    pctBar.style.width = `${clampedPct}%`;
  }

  animateValue("kpi-quantidade-vendida", kpis.quantidade_vendida, false);
  animateValue("kpi-ticket-medio", kpis.ticket_medio, true);
}

// Shared tooltip config
function tooltipConfig() {
  return {
    backgroundColor: "rgba(17, 24, 39, 0.95)",
    borderColor: "rgba(75, 85, 99, 0.3)",
    borderWidth: 1,
    titleColor: "#f9fafb",
    bodyColor: "#d1d5db",
    titleFont: { family: "Inter", size: 12, weight: "600" },
    bodyFont: { family: "Inter", size: 12 },
    padding: 10,
    cornerRadius: 8,
    displayColors: true,
    boxPadding: 4,
    callbacks: {
      label: function(ctx) {
        const val = ctx.parsed.y ?? ctx.parsed;
        if (typeof val === "number") {
          return ` ${ctx.dataset.label}: ${formatCurrency(val)}`;
        }
        return ctx.dataset.label;
      }
    }
  };
}

// 1. LINE CHART: Faturamento Mensal
function renderFaturamentoMensalChart(data) {
  const ctx = document.getElementById("chart-faturamento-mensal").getContext("2d");
  
  if (charts.faturamentoMensal) charts.faturamentoMensal.destroy();

  const gradBlue = ctx.createLinearGradient(0, 0, 0, 280);
  gradBlue.addColorStop(0, "rgba(59, 130, 246, 0.12)");
  gradBlue.addColorStop(1, "rgba(59, 130, 246, 0.0)");

  const gradGreen = ctx.createLinearGradient(0, 0, 0, 280);
  gradGreen.addColorStop(0, "rgba(16, 185, 129, 0.10)");
  gradGreen.addColorStop(1, "rgba(16, 185, 129, 0.0)");

  const labels = ["Início", ...data.map(d => d.mes)];
  const fatBruto = [0, ...data.map(d => d.faturamento_bruto)];
  const recLiquida = [0, ...data.map(d => d.receita_liquida)];

  charts.faturamentoMensal = new Chart(ctx, {
    type: "line",
    data: {
      labels: labels,
      datasets: [
        {
          label: "Fat. Bruto",
          data: fatBruto,
          borderColor: COLORS.blue.main,
          backgroundColor: gradBlue,
          borderWidth: 2,
          fill: true,
          tension: 0.3,
          pointBackgroundColor: COLORS.blue.main,
          pointBorderColor: "#1f2937",
          pointBorderWidth: 2,
          pointRadius: 3,
          pointHoverRadius: 5
        },
        {
          label: "Receita Líquida",
          data: recLiquida,
          borderColor: COLORS.emerald.main,
          backgroundColor: gradGreen,
          borderWidth: 2,
          fill: true,
          tension: 0.3,
          pointBackgroundColor: COLORS.emerald.main,
          pointBorderColor: "#1f2937",
          pointBorderWidth: 2,
          pointRadius: 3,
          pointHoverRadius: 5
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      interaction: { mode: "index", intersect: false },
      animation: { duration: 600, easing: "easeOutQuart" },
      plugins: {
        legend: {
          labels: { 
            color: LEGEND_COLOR, 
            font: { family: "Inter", size: 11, weight: "500" },
            usePointStyle: true,
            pointStyle: "circle",
            padding: 16
          }
        },
        tooltip: tooltipConfig()
      },
      scales: {
        x: {
          grid: { color: GRID_COLOR, drawBorder: false },
          ticks: { color: TICK_COLOR, font: { family: "Inter", size: 11 } },
          border: { display: false }
        },
        y: {
          beginAtZero: true,
          grid: { color: GRID_COLOR, drawBorder: false },
          ticks: { color: TICK_COLOR, font: { family: "Inter", size: 11 } },
          border: { display: false }
        }
      }
    }
  });
}

// 2. BAR CHART: Comparação por Filial
function renderReceitaFilialChart(data) {
  const ctx = document.getElementById("chart-receita-filial").getContext("2d");
  
  if (charts.receitaFilial) charts.receitaFilial.destroy();

  charts.receitaFilial = new Chart(ctx, {
    type: "bar",
    data: {
      labels: data.map(d => d.filial),
      datasets: [
        {
          label: "Receita Líquida",
          data: data.map(d => d.receita_liquida),
          backgroundColor: "rgba(59, 130, 246, 0.6)",
          hoverBackgroundColor: COLORS.blue.hover,
          borderColor: COLORS.blue.main,
          borderWidth: 1,
          borderRadius: 4
        },
        {
          label: "Margem Bruta",
          data: data.map(d => d.margem_bruta),
          backgroundColor: "rgba(139, 92, 246, 0.5)",
          hoverBackgroundColor: COLORS.purple.hover,
          borderColor: COLORS.purple.main,
          borderWidth: 1,
          borderRadius: 4
        }
      ]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      animation: { duration: 700, easing: "easeOutQuart" },
      plugins: {
        legend: {
          labels: { 
            color: LEGEND_COLOR, 
            font: { family: "Inter", size: 11, weight: "500" },
            usePointStyle: true,
            pointStyle: "rectRounded",
            padding: 16
          }
        },
        tooltip: tooltipConfig()
      },
      scales: {
        x: {
          grid: { color: GRID_COLOR, drawBorder: false },
          ticks: { color: TICK_COLOR, font: { family: "Inter", size: 11 } },
          border: { display: false }
        },
        y: {
          beginAtZero: true,
          grid: { color: GRID_COLOR, drawBorder: false },
          ticks: { color: TICK_COLOR, font: { family: "Inter", size: 11 } },
          border: { display: false }
        }
      }
    }
  });
}

// 3. DOUGHNUT: Análise por Categoria
function renderReceitaCategoriaChart(data) {
  const ctx = document.getElementById("chart-receita-categoria").getContext("2d");
  
  if (charts.receitaCategoria) charts.receitaCategoria.destroy();

  const segmentColors = [
    "rgba(59, 130, 246, 0.7)",
    "rgba(16, 185, 129, 0.65)",
    "rgba(139, 92, 246, 0.65)",
    "rgba(245, 158, 11, 0.65)",
    "rgba(244, 63, 94, 0.60)",
    "rgba(14, 165, 233, 0.60)",
    "rgba(99, 102, 241, 0.60)",
    "rgba(20, 184, 166, 0.60)"
  ];

  charts.receitaCategoria = new Chart(ctx, {
    type: "doughnut",
    data: {
      labels: data.map(d => d.categoria),
      datasets: [{
        data: data.map(d => d.receita_liquida),
        backgroundColor: segmentColors,
        borderColor: "#1f2937",
        borderWidth: 3,
        hoverOffset: 6
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: "65%",
      animation: { duration: 800, easing: "easeOutQuart" },
      plugins: {
        legend: {
          position: "right",
          labels: { 
            color: LEGEND_COLOR, 
            font: { family: "Inter", size: 11, weight: "500" },
            usePointStyle: true,
            pointStyle: "circle",
            padding: 12
          }
        },
        tooltip: {
          ...tooltipConfig(),
          callbacks: {
            label: function(ctx) {
              const val = ctx.parsed;
              const total = ctx.dataset.data.reduce((a, b) => a + b, 0);
              const pct = total > 0 ? ((val / total) * 100).toFixed(1) : 0;
              return ` ${ctx.label}: ${formatCurrency(val)} (${pct}%)`;
            }
          }
        }
      }
    }
  });
}

// 4. TABLE: Produtos Mais Vendidos
function renderProdutosMaisVendidosTable(data) {
  const tbody = document.getElementById("top-products-table-body");
  tbody.innerHTML = "";

  if (data.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="5" class="py-8 text-center text-gray-500 text-xs">Nenhum produto encontrado para os filtros selecionados.</td>
      </tr>
    `;
    return;
  }

  const maxQty = Math.max(...data.map(d => d.quantidade_vendida), 1);

  data.forEach((p, idx) => {
    const tr = document.createElement("tr");
    tr.className = "hover:bg-blue-500/[0.03] transition text-gray-300";
    
    const pctVolume = (p.quantidade_vendida / maxQty) * 100;
    
    let rankClass = "default";
    if (idx === 0) rankClass = "top-1";
    else if (idx === 1) rankClass = "top-2";
    else if (idx === 2) rankClass = "top-3";
    
    tr.innerHTML = `
      <td class="py-3 px-3">
        <span class="rank-badge ${rankClass}">${idx + 1}</span>
      </td>
      <td class="py-3 px-3 text-white font-medium text-xs">${p.produto}</td>
      <td class="py-3 px-3 text-gray-500 text-xs">${p.categoria}</td>
      <td class="py-3 px-3 text-right text-xs">
        <div class="flex items-center justify-end space-x-2">
          <span>${p.quantidade_vendida.toLocaleString("pt-BR")}</span>
          <div class="hidden sm:block w-12 bg-gray-700/30 h-1 rounded-full overflow-hidden">
            <div class="bg-blue-500/60 h-full rounded-full" style="width: ${pctVolume}%"></div>
          </div>
        </div>
      </td>
      <td class="py-3 px-3 text-right font-semibold text-emerald-400 text-xs">${formatCurrency(p.receita_liquida)}</td>
    `;
    tbody.appendChild(tr);
  });
}

// Loading overlay
function showLoading(isLoading) {
  const loader = document.getElementById("loading-overlay");
  if (isLoading) {
    loader.classList.remove("pointer-events-none", "opacity-0");
    loader.classList.add("opacity-100");
  } else {
    loader.classList.add("pointer-events-none", "opacity-0");
    loader.classList.remove("opacity-100");
  }
}

// Error overlay
function showErrorState(isError) {
  const errOverlay = document.getElementById("error-overlay");
  if (isError) {
    errOverlay.classList.remove("hidden");
  } else {
    errOverlay.classList.add("hidden");
  }
}

// Connection status badge (header)
function setConnectionStatus(isConnected) {
  const badge = document.getElementById("connection-status");
  const dot = document.getElementById("status-dot");
  const text = document.getElementById("status-text");
  if (!badge || !dot || !text) return;

  if (isConnected) {
    badge.className = "flex items-center space-x-2 px-3 py-1.5 rounded-lg border border-emerald-500/15 bg-emerald-500/5";
    dot.className = "w-2 h-2 rounded-full bg-emerald-500 status-dot";
    text.className = "text-[11px] font-medium text-emerald-400";
    text.textContent = "Conectado";
  } else {
    badge.className = "flex items-center space-x-2 px-3 py-1.5 rounded-lg border border-red-500/20 bg-red-500/5";
    dot.className = "w-2 h-2 rounded-full bg-red-500 status-dot";
    text.className = "text-[11px] font-medium text-red-400";
    text.textContent = "Desconectado";
  }
}
