<%@ Page Title="Kategori Ürünleri" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Kategori.aspx.cs" Inherits="MarketETicaret.Kategori" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .product-card { transition: transform 0.3s, box-shadow 0.3s; border: 1px solid #eee; }
        .product-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); border-color: #ff6600; }
        .product-img { height: 200px; object-fit: contain; padding: 10px; }
        .price-tag { color: #ff6600; font-size: 1.2rem; font-weight: bold; }
        .category-list a { text-decoration: none; color: #555; display: block; padding: 10px; border-bottom: 1px solid #eee; transition: 0.2s; }
        .category-list a:hover { background-color: #ff6600; color: white; padding-left: 15px; }
        .active-category { background-color: #ff6600 !important; color: white !important; }
    </style>

    <div class="container mt-4">
        <div class="row">
            
            <div class="col-lg-3 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <i class="fas fa-list-ul me-2"></i> Kategoriler
                    </div>
                    <div class="card-body p-0 category-list">
                        <asp:Repeater ID="rptKategoriler" runat="server">
                            <ItemTemplate>
                                <a href='Kategori.aspx?id=<%# Eval("KategoriID") %>' 
                                   class='<%# Convert.ToInt32(Eval("KategoriID")) == RequestKategoriID ? "active-category" : "" %>'>
                                    <i class="fas fa-chevron-right me-2"></i> <%# Eval("KategoriAdi") %>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <div class="col-lg-9">
                
                <h3 class="mb-3 border-bottom pb-2 text-uppercase">
                    <asp:Label ID="lblKategoriAdi" runat="server" Text="Ürünler"></asp:Label>
                </h3>

                <asp:Panel ID="pnlUrunYok" runat="server" Visible="false">
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle fa-2x mb-3"></i><br />
                        Bu kategoride henüz ürün bulunmamaktadır.
                    </div>
                </asp:Panel>

                <div class="row">
                    <asp:Repeater ID="rptUrunler" runat="server" OnItemCommand="rptUrunler_ItemCommand">
                        <ItemTemplate>
                            <div class="col-md-4 col-sm-6 mb-4">
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
        </div>
    </div>

</asp:Content>