<%@ Page Title="Sipariş Alındı" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SiparisTamamlandi.aspx.cs" Inherits="MarketETicaret.SiparisTamamlandi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 text-center">
                
                <div class="card shadow-lg p-5 border-0 rounded-3">
                    <div class="card-body">
                        <div class="mb-4">
                            <i class="fas fa-check-circle text-success" style="font-size: 80px;"></i>
                        </div>

                        <h2 class="text-success fw-bold">Siparişiniz Başarıyla Alındı!</h2>
                        <p class="lead text-muted mt-3">
                            Teşekkür ederiz. Ödemeniz onaylandı ve siparişiniz hazırlanma aşamasına geçti.
                        </p>

                        <hr class="my-4" />

                        <p>
                            Siparişinizin durumunu takip etmek için aşağıdaki butonu kullanabilirsiniz.
                        </p>

                        <div class="d-flex justify-content-center gap-3 mt-4">
                            <a href="Default.aspx" class="btn btn-outline-secondary btn-lg">
                                <i class="fas fa-shopping-basket me-2"></i>Alışverişe Devam Et
                            </a>

                            <a href="Siparislerim.aspx" class="btn btn-success btn-lg">
                                <i class="fas fa-box-open me-2"></i>Siparişlerim
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>