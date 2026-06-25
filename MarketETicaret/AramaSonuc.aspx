<%@ Page Title="Arama Sonuçları" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AramaSonuc.aspx.cs" Inherits="MarketETicaret.AramaSonuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <style>
        .product-card { transition: transform 0.3s, box-shadow 0.3s; border: 1px solid #eee; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); border-color: #ff6600; }
        .product-img { height: 200px; object-fit: contain; padding: 10px; }
        .price-tag { color: #ff6600; font-size: 1.2rem; font-weight: bold; }
    </style>

    <div class="container mt-4 mb-5">
        
        <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-4">
            <h3>
                <i class="fas fa-search me-2 text-muted"></i>
                Arama Sonuçları: <span class="text-primary">"<asp:Label ID="lblArananKelime" runat="server"></asp:Label>"</span>
            </h3>
            <span class="text-muted"><asp:Label ID="lblSonucSayisi" runat="server"></asp:Label> ürün bulundu</span>
        </div>

        <asp:Panel ID="pnlUrunYok" runat="server" Visible="false">
            <div class="alert alert-warning text-center p-5">
                <i class="fas fa-search-minus fa-3x mb-3"></i><br />
                <h4>Üzgünüz, aramanızla eşleşen bir ürün bulamadık.</h4>
                <p>Lütfen kelimeyi kontrol edin veya farklı anahtar kelimeler deneyin.</p>
                <a href="Default.aspx" class="btn btn-outline-dark mt-2">Ana Sayfaya Dön</a>
            </div>
        </asp:Panel>

        <div class="row">
            <asp:Repeater ID="rptUrunler" runat="server" OnItemCommand="rptUrunler_ItemCommand">
                <ItemTemplate>
                    <div class="col-md-3 col-sm-6 mb-4">
                        <div class="card product-card h-100">
                            
                            <a href='UrunDetay.aspx?id=<%# Eval("UrunID") %>'>
                                <img src='<%# Eval("ResimYolu") %>' class="card-img-top product-img" alt='<%# Eval("UrunAdi") %>'>
                            </a>
                            
                            <div class="card-body d-flex flex-column">
                                
                                <h5 class="card-title text-truncate" title='<%# Eval("UrunAdi") %>'>
                                    <a href='UrunDetay.aspx?id=<%# Eval("UrunID") %>' class="text-decoration-none text-dark">
                                        <%# Eval("UrunAdi") %>
                                    </a>
                                </h5>

                                <p class="card-text small text-muted text-truncate">
                                    <%# Eval("Aciklama") %>
                                </p>
                                
                                <div class="mt-auto">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <span class="price-tag"><%# Eval("Fiyat", "{0:C}") %></span>
                                        
                                        <span class='badge bg-<%# Convert.ToInt32(Eval("Stok")) > 0 ? "success" : "danger" %>'>
                                            <%# Convert.ToInt32(Eval("Stok")) > 0 ? "Stokta Var" : "Tükendi" %>
                                        </span>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle" 
                                            CssClass="btn btn-outline-primary"
                                            CommandName="SepeteEkle"
                                            CommandArgument='<%# Eval("UrunID") %>'
                                            Enabled='<%# Convert.ToInt32(Eval("Stok")) > 0 %>' />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

    </div>
</asp:Content>