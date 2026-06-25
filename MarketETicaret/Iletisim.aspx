<%@ Page Title="İletişim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Iletisim.aspx.cs" Inherits="MarketETicaret.IletisimSayfasi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container mt-5 mb-5">
        <h2 class="mb-4 border-bottom pb-2">Bize Ulaşın</h2>

        <div class="row">
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm h-100 border-0 bg-light">
                    <div class="card-body">
                        <h4 class="card-title text-primary mb-4">İletişim Bilgileri</h4>
                        
                        <div class="d-flex align-items-start mb-3">
                            <div class="me-3 text-primary"><i class="fas fa-map-marker-alt fa-2x"></i></div>
                            <div>
                                <h6 class="fw-bold mb-1">Adres</h6>
                                <p class="mb-0 text-muted">
                                    <asp:Label ID="lblAdres" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>

                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3 text-success"><i class="fas fa-phone-alt fa-2x"></i></div>
                            <div>
                                <h6 class="fw-bold mb-1">Telefon</h6>
                                <p class="mb-0 text-muted">
                                    <asp:Label ID="lblTelefon" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>

                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3 text-danger"><i class="fas fa-envelope fa-2x"></i></div>
                            <div>
                                <h6 class="fw-bold mb-1">E-Posta</h6>
                                <p class="mb-0 text-muted">
                                    <asp:Label ID="lblEmail" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <div class="col-lg-8 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body p-0">
                        <div class="ratio ratio-16x9 h-100">
                            <asp:Literal ID="ltrHarita" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>