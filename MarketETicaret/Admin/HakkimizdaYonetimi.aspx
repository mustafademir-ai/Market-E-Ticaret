<%@ Page Title="Hakkımızda Yönetimi" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="HakkimizdaYonetimi.aspx.cs" Inherits="MarketETicaret.Admin.HakkimizdaYonetimi" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- CKEditor Kütüphanesi --%>
    <script src="https://cdn.ckeditor.com/4.19.1/standard/ckeditor.js"></script>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-gray-800"><i class="fas fa-info-circle me-2"></i>Kurumsal Sayfa Yönetimi</h2>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow border-top-primary">
                <div class="card-header bg-white py-3">
                    <h5 class="m-0 font-weight-bold text-primary">
                        Hakkımızda / Vizyon / Misyon Düzenle
                    </h5>
                </div>
                <div class="card-body">
                    
                    <%-- Bilgilendirme Mesajı --%>
                    <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3"></asp:Label>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Vizyonumuz</label>
                            <asp:TextBox ID="txtVizyon" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Vizyon metni buraya..."></asp:TextBox>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Misyonumuz</label>
                            <asp:TextBox ID="txtMisyon" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Misyon metni buraya..."></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Genel İçerik (Hakkımızda Yazısı)</label>
                        <%-- CKEditor bu TextBox'a bağlanacak --%>
                        <asp:TextBox ID="txtIcerik" runat="server" TextMode="MultiLine" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                    </div>

                    <div class="d-flex justify-content-end border-top pt-3">
                        <asp:Button ID="btnKaydet" runat="server" Text="Değişiklikleri Kaydet" CssClass="btn btn-success px-4 btn-lg" OnClick="btnKaydet_Click" />
                    </div>

                </div>
            </div>
        </div>
    </div>

    <%-- CKEditor Başlatma Scripti --%>
    <script>
        // Sayfa yüklendiğinde çalışsın
        window.onload = function () {
            if (CKEDITOR) {
                CKEDITOR.replace('txtIcerik');
            }
        };
    </script>

</asp:Content>