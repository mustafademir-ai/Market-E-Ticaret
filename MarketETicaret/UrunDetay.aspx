<%@ Page Title="Ürün Detayı" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UrunDetay.aspx.cs" Inherits="MarketETicaret.UrunDetay" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 mb-5">
        
        <div class="card shadow-sm border-0">
            <div class="card-body p-4">
                <div class="row">
                    
                    <div class="col-md-5 text-center bg-light rounded d-flex align-items-center justify-content-center" style="min-height: 400px;">
                        <asp:Image ID="imgUrun" runat="server" CssClass="img-fluid" style="max-height: 350px;" />
                    </div>

                    <div class="col-md-7 mt-4 mt-md-0">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="Default.aspx" class="text-decoration-none">Ana Sayfa</a></li>
                                <li class="breadcrumb-item"><a href="Kategori.aspx" class="text-decoration-none">Kategoriler</a></li>
                                <li class="breadcrumb-item active" aria-current="page"><asp:Label ID="lblKategoriAdi" runat="server"></asp:Label></li>
                            </ol>
                        </nav>

                        <h2 class="fw-bold mb-3"><asp:Label ID="lblUrunAdi" runat="server"></asp:Label></h2>
                        
                        <div class="mb-3">
                            <span class="h3 text-primary fw-bold me-3"><asp:Label ID="lblFiyat" runat="server"></asp:Label></span>
                            <asp:Label ID="lblStokDurumu" runat="server" CssClass="badge bg-success"></asp:Label>
                        </div>

                        <p class="text-muted mb-4" style="line-height: 1.8;">
                            <asp:Literal ID="ltrAciklama" runat="server"></asp:Literal>
                        </p>

                        <div class="d-flex align-items-center gap-3">
                            <div class="input-group" style="width: 130px;">
                                <span class="input-group-text">Adet</span>
                                <asp:TextBox ID="txtAdet" runat="server" TextMode="Number" Text="1" min="1" max="10" CssClass="form-control text-center"></asp:TextBox>
                            </div>
                            
                            <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle" 
                                CssClass="btn btn-primary btn-lg px-4" OnClick="btnSepeteEkle_Click" />
                        </div>

                        <div class="mt-4 pt-3 border-top">
                            <small class="text-muted"><i class="fas fa-shipping-fast me-2"></i>Aynı gün kargo imkanı.</small><br />
                            <small class="text-muted"><i class="fas fa-shield-alt me-2"></i>Güvenli ödeme ve iade garantisi.</small>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        </div>
</asp:Content>