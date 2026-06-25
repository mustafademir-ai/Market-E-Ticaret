<%@ Page Title="İletişim Yönetimi" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="IletisimYonetimi.aspx.cs" Inherits="MarketETicaret.Admin.IletisimYonetimi" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-gray-800"><i class="fas fa-address-book me-2"></i>İletişim Bilgileri Yönetimi</h2>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow border-top-primary">
                <div class="card-header bg-white py-3">
                    <h5 class="m-0 font-weight-bold text-primary">
                        İletişim ve Harita Ayarları
                    </h5>
                </div>
                <div class="card-body">
                    
                    <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3"></asp:Label>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Adres</label>
                        <asp:TextBox ID="txtAdres" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Açık adres..."></asp:TextBox>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Telefon</label>
                            <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control" placeholder="05XX..."></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">E-Posta</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="info@site.com"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold text-danger">Google Maps "Harita Yerleştirme" Kodu (iframe)</label>
                        <div class="alert alert-warning py-2 small">
                            <i class="fas fa-info-circle"></i> Google Maps'te konumunuzu bulun -> Paylaş -> <b>Harita yerleştirme</b> sekmesine gelin -> "HTML'yi Kopyala" diyerek aldığınız kodu buraya yapıştırın.
                        </div>
                        <asp:TextBox ID="txtHarita" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5"></asp:TextBox>
                    </div>

                    <div class="d-flex justify-content-end border-top pt-3">
                        <asp:Button ID="btnKaydet" runat="server" Text="Bilgileri Kaydet" CssClass="btn btn-success px-4 btn-lg" OnClick="btnKaydet_Click" />
                    </div>

                </div>
            </div>
        </div>
        
        <%-- Önizleme Alanı --%>
        <div class="col-lg-4">
             <div class="card shadow">
                 <div class="card-header bg-secondary text-white">
                     Harita Önizleme
                 </div>
                 <div class="card-body p-0">
                     <asp:Literal ID="ltrHaritaOnizleme" runat="server"></asp:Literal>
                 </div>
             </div>
        </div>
    </div>

</asp:Content>