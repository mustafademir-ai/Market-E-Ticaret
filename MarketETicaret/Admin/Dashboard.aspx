<%@ Page Title="Panel Özeti" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="MarketETicaret.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800"><i class="fas fa-chart-line me-2"></i>Genel Bakış</h1>
        <a href="SiparisYonetimi.aspx" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
            <i class="fas fa-list fa-sm text-white-50 me-1"></i> Siparişleri Yönet
        </a>
    </div>

    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2" style="border-left: 5px solid #1cc88a;">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">Toplam Ciro</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <asp:Label ID="lblCiro" runat="server" Text="0 ₺"></asp:Label>
                            </div>
                        </div>
                        <div class="col-auto"><i class="fas fa-lira-sign fa-2x text-gray-300"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2" style="border-left: 5px solid #4e73df;">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Toplam Sipariş</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <asp:Label ID="lblSiparisSayisi" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                        <div class="col-auto"><i class="fas fa-shopping-cart fa-2x text-gray-300"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2" style="border-left: 5px solid #36b9cc;">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">Kayıtlı Müşteri</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <asp:Label ID="lblMusteriSayisi" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                        <div class="col-auto"><i class="fas fa-users fa-2x text-gray-300"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2" style="border-left: 5px solid #f6c23e;">
                <div class="card-body">
                    <div class="row no-gutters align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">Ürün Çeşidi</div>
                            <div class="h5 mb-0 font-weight-bold text-gray-800">
                                <asp:Label ID="lblUrunSayisi" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                        <div class="col-auto"><i class="fas fa-box fa-2x text-gray-300"></i></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-white">
                    <h6 class="m-0 font-weight-bold text-primary">Aylık Kazanç Grafiği (Son 6 Ay)</h6>
                </div>
                <div class="card-body">
                    <div class="chart-area" style="height: 320px;">
                        <canvas id="myAreaChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-white">
                    <h6 class="m-0 font-weight-bold text-primary">Kategori Dağılımı</h6>
                </div>
                <div class="card-body">
                    <div class="chart-pie" style="height: 320px;">
                        <canvas id="myPieChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        
        <div class="col-lg-6 mb-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-white">
                    <h6 class="m-0 font-weight-bold text-primary">Son Siparişler</h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Müşteri</th>
                                    <th>Tutar</th>
                                    <th>Durum</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptSonSiparisler" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("SiparisID") %></td>
                                            <td><%# Eval("MusteriAdi") %></td>
                                            <td class="text-success fw-bold"><%# Eval("ToplamTutar", "{0:C}") %></td>
                                            <td><span class="badge bg-secondary"><%# Eval("SiparisDurumu") %></span></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6 mb-4">
            <div class="card shadow mb-4">
                <div class="card-header py-3 bg-white">
                    <h6 class="m-0 font-weight-bold text-primary">En Çok Satan 5 Ürün (Adet)</h6>
                </div>
                <div class="card-body">
                    <div class="chart-bar" style="height: 300px;">
                        <canvas id="myBarChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hdnAylar" runat="server" />
    <asp:HiddenField ID="hdnKazanc" runat="server" />
    <asp:HiddenField ID="hdnKategoriIsimleri" runat="server" />
    <asp:HiddenField ID="hdnKategoriDegerleri" runat="server" />
    <asp:HiddenField ID="hdnUrunIsimleri" runat="server" />
    <asp:HiddenField ID="hdnUrunSatis" runat="server" />

    <script>
        // Verileri Gizli Alanlardan Al
        var aylar = document.getElementById('<%= hdnAylar.ClientID %>').value.split(',');
        var kazanclar = document.getElementById('<%= hdnKazanc.ClientID %>').value.split(',');
        
        var katIsim = document.getElementById('<%= hdnKategoriIsimleri.ClientID %>').value.split(',');
        var katDeger = document.getElementById('<%= hdnKategoriDegerleri.ClientID %>').value.split(',');

        var urunIsim = document.getElementById('<%= hdnUrunIsimleri.ClientID %>').value.split(',');
        var urunSatis = document.getElementById('<%= hdnUrunSatis.ClientID %>').value.split(',');

        // 1. ÇİZGİ GRAFİK (AYLIK KAZANÇ)
        var ctxArea = document.getElementById("myAreaChart");
        if (ctxArea) {
            new Chart(ctxArea, {
                type: 'line',
                data: {
                    labels: aylar,
                    datasets: [{
                        label: "Kazanç (₺)",
                        lineTension: 0.3,
                        backgroundColor: "rgba(78, 115, 223, 0.05)",
                        borderColor: "rgba(78, 115, 223, 1)",
                        pointRadius: 3,
                        pointBackgroundColor: "rgba(78, 115, 223, 1)",
                        pointBorderColor: "rgba(78, 115, 223, 1)",
                        pointHoverRadius: 3,
                        pointHoverBackgroundColor: "rgba(78, 115, 223, 1)",
                        pointHoverBorderColor: "rgba(78, 115, 223, 1)",
                        pointHitRadius: 10,
                        pointBorderWidth: 2,
                        data: kazanclar,
                    }],
                },
                options: {
                    maintainAspectRatio: false,
                    layout: { padding: { left: 10, right: 25, top: 25, bottom: 0 } },
                    legend: { display: false }
                }
            });
        }

        // 2. YUVARLAK GRAFİK (KATEGORİLER)
        var ctxPie = document.getElementById("myPieChart");
        if (ctxPie) {
            new Chart(ctxPie, {
                type: 'doughnut',
                data: {
                    labels: katIsim,
                    datasets: [{
                        data: katDeger,
                        backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b', '#858796'],
                        hoverBackgroundColor: ['#2e59d9', '#17a673', '#2c9faf', '#dda20a', '#be2617', '#60616f'],
                        hoverBorderColor: "rgba(234, 236, 244, 1)",
                    }],
                },
                options: {
                    maintainAspectRatio: false,
                    tooltips: {
                        backgroundColor: "rgb(255,255,255)",
                        bodyFontColor: "#858796",
                        borderColor: '#dddfeb',
                        borderWidth: 1,
                        xPadding: 15,
                        yPadding: 15,
                        displayColors: false,
                        caretPadding: 10,
                    },
                    legend: { display: true, position: 'bottom' },
                    cutoutPercentage: 70,
                },
            });
        }

        // 3. BAR GRAFİK (EN ÇOK SATANLAR)
        var ctxBar = document.getElementById("myBarChart");
        if (ctxBar) {
            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: urunIsim,
                    datasets: [{
                        label: "Satış Adedi",
                        backgroundColor: "#4e73df",
                        hoverBackgroundColor: "#2e59d9",
                        borderColor: "#4e73df",
                        data: urunSatis,
                    }],
                },
                options: {
                    maintainAspectRatio: false,
                    layout: { padding: { left: 10, right: 25, top: 25, bottom: 0 } },
                    scales: {
                        xAxes: [{ gridLines: { display: false, drawBorder: false }, ticks: { maxTicksLimit: 6 } }],
                        yAxes: [{ ticks: { min: 0, maxTicksLimit: 5, padding: 10 }, gridLines: { color: "rgb(234, 236, 244)", zeroLineColor: "rgb(234, 236, 244)", drawBorder: false, borderDash: [2], zeroLineBorderDash: [2] } }],
                    },
                    legend: { display: false },
                }
            });
        }
    </script>

</asp:Content>