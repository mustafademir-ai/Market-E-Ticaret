<%@ Page Title="Ana Sayfa" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MarketETicaret.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* --- GÖRSEL ŞÖLEN İÇİN ÖZEL CSS --- */
        
        /* Ürün Kartı Temel Yapısı */
        .product-card {
            border: none;
            border-radius: 15px;
            background: #fff;
            transition: all 0.4s ease;
            overflow: hidden;
            position: relative;
        }

        /* Hover Efekti: Kart yukarı kalkar ve gölge artar */
        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        /* Resim Alanı */
        .img-wrapper {
            height: 220px;
            overflow: hidden;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fff;
        }

        /* Resim Zoom Efekti */
        .product-img {
            max-height: 100%;
            max-width: 100%;
            transition: transform 0.5s ease;
        }

        .product-card:hover .product-img {
            transform: scale(1.1); /* Resim %10 büyür */
        }

        /* Fiyat Etiketi */
        .price-tag {
            color: #2c3e50;
            font-size: 1.3rem;
            font-weight: 800;
        }

        /* Kategori Etiketi */
        .category-badge {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #95a5a6;
            font-weight: 600;
        }

        /* Sepete Ekle Butonu */
        .btn-add-cart {
            background-color: #fff;
            color: #ff6600;
            border: 2px solid #ff6600;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-add-cart:hover {
            background-color: #ff6600;
            color: white;
            box-shadow: 0 5px 15px rgba(255, 102, 0, 0.3);
        }

        /* Sol Menü Linkleri */
        .category-list a {
            text-decoration: none;
            color: #555;
            display: block;
            padding: 12px 15px;
            border-bottom: 1px solid #f1f1f1;
            transition: 0.2s;
            font-weight: 500;
        }
        .category-list a:hover {
            background-color: #ff6600;
            color: white;
            padding-left: 20px;
            border-radius: 0 25px 25px 0;
        }

        /* Kampanya Banner (Önceki tasarım korundu) */
        .campaign-banner {
            background: linear-gradient(135deg, #ff9966 0%, #ff5e62 100%);
            color: white;
            border-radius: 15px;
            overflow: hidden;
            position: relative;
        }
        .campaign-img {
            filter: drop-shadow(0 10px 15px rgba(0,0,0,0.2));
            transition: transform 0.4s;
        }
        .campaign-banner:hover .campaign-img {
            transform: scale(1.05) rotate(-5deg);
        }
    </style>

    <div class="row">
        <div class="col-lg-3 d-none d-lg-block">
            <div class="card shadow-sm border-0 mb-4" style="border-radius: 15px; overflow: hidden;">
                <div class="card-header bg-dark text-white py-3">
                    <h6 class="m-0 fw-bold"><i class="fas fa-bars me-2"></i> KATEGORİLER</h6>
                </div>
                <div class="card-body p-0 category-list">
                    <asp:Repeater ID="rptKategoriler" runat="server">
                        <ItemTemplate>
                            <a href='Kategori.aspx?id=<%# Eval("KategoriID") %>'>
                                <i class="fas fa-caret-right me-2"></i> <%# Eval("KategoriAdi") %>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="card shadow-sm border-0" style="border-radius: 15px; overflow: hidden;">
                <img src="https://via.placeholder.com/300x400/2c3e50/ffffff?text=Haftanin+Firsati" class="card-img-top" alt="Reklam">
            </div>
        </div>

        <div class="col-lg-9">
            
            <div class="campaign-banner mb-5 shadow p-4 d-flex align-items-center justify-content-between">
                <div class="ps-3 py-3" style="z-index: 2;">
                    <span class="badge bg-white text-danger mb-2 px-3 py-2 shadow-sm">★ SINIRSIZ KAMPANYA</span>
                    <h1 class="display-5 fw-bold fst-italic mb-2">DEV İNDİRİM GÜNLERİ</h1>
                    <p class="lead mb-4 text-white-50">Seçili tüm teknoloji ve moda ürünlerinde %70'e varan fırsatlar!</p>
                    <a href="#" class="btn btn-light text-danger fw-bold px-4 py-2 rounded-pill shadow">Hemen İncele <i class="fas fa-arrow-right ms-2"></i></a>
                </div>
                <div class="d-none d-md-block pe-4">
                     
                    <img src="https://cdn-icons-png.flaticon.com/512/3081/3081648.png" alt="İndirim" class="campaign-img" style="max-height: 220px;">
                </div>
            </div>
            
            <div class="d-flex align-items-center justify-content-between mb-4 pb-2 border-bottom">
                <h3 class="m-0 fw-bold text-dark">
                    <i class="fas fa-star text-warning me-2"></i>Sizin İçin Seçtiklerimiz
                </h3>
                <span class="text-muted">Editörün Seçimi</span>
            </div>
            
            <div class="row">
                <asp:Repeater ID="rptUrunler" runat="server" OnItemCommand="rptUrunler_ItemCommand">
                    <ItemTemplate>
                        <div class="col-xl-4 col-md-6 mb-4">
                            <div class="card product-card h-100 shadow-sm">
                                
                                <%-- Öne Çıkan Etiketi (Sol Üst Köşe) --%>
                                <div class="position-absolute top-0 start-0 m-3" style="z-index: 5;">
                                    <span class="badge bg-warning text-dark shadow-sm px-2 py-1">
                                        <i class="fas fa-bolt"></i> Fırsat
                                    </span>
                                </div>

                                <%-- Resim Alanı --%>
                                <div class="img-wrapper">
                                    <a href='UrunDetay.aspx?id=<%# Eval("UrunID") %>'>
                                        <img src='<%# Eval("ResimYolu") %>' class="product-img" alt='<%# Eval("UrunAdi") %>'>
                                    </a>
                                </div>
                                
                                <div class="card-body d-flex flex-column pt-0">
                                    <%-- Kategori --%>
                                    <div class="mb-2">
                                        <span class="category-badge"><%# Eval("KategoriAdi") %></span>
                                    </div>

                                    <%-- Ürün Adı --%>
                                    <h5 class="card-title text-truncate mb-3">
                                        <a href='UrunDetay.aspx?id=<%# Eval("UrunID") %>' class="text-decoration-none text-dark fw-bold" title='<%# Eval("UrunAdi") %>'>
                                            <%# Eval("UrunAdi") %>
                                        </a>
                                    </h5>
                                    
                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-end mb-3">
                                            <%-- Fiyat --%>
                                            <span class="price-tag"><%# Eval("Fiyat", "{0:C}") %></span>
                                            
                                            <%-- Stok Durumu (Ufak nokta) --%>
                                            <small class='<%# Convert.ToInt32(Eval("Stok")) > 0 ? "text-success" : "text-danger" %> fw-bold'>
                                                <i class="fas fa-circle fa-xs"></i> <%# Convert.ToInt32(Eval("Stok")) > 0 ? "Stokta" : "Tükendi" %>
                                            </small>
                                        </div>

                                        <%-- Sepete Ekle Butonu --%>
                                        <div class="d-grid">
                                            <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle" 
                                                CssClass="btn btn-add-cart py-2"
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
                
                <%-- Eğer ürün yoksa uyarı mesajı --%>
                <asp:Panel ID="pnlUrunYok" runat="server" Visible="false">
                    <div class="col-12">
                        <div class="alert alert-light text-center shadow-sm py-5">
                            <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Şu an öne çıkan ürün bulunmamaktadır.</h5>
                        </div>
                    </div>
                </asp:Panel>
            </div>

        </div>
    </div>

</asp:Content>