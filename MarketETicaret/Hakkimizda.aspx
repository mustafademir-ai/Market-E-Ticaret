<%@ Page Title="Hakkımızda" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Hakkimizda.aspx.cs" Inherits="MarketETicaret.HakkimizdaSayfasi" %>
<%-- Inherits ismine dikkat et, çakışma olmasın diye HakkimizdaSayfasi dedim --%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container mt-5 mb-5">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="mb-4 border-bottom pb-2">Hakkımızda</h1>
                
                <%-- CKEditor'den gelen HTML içeriği buraya basılacak --%>
                <div class="content-area mb-5">
                    <asp:Literal ID="ltrIcerik" runat="server"></asp:Literal>
                </div>

                <div class="row mt-4">
                    <div class="col-md-6 mb-4">
                        <div class="card h-100 shadow-sm border-0 bg-light">
                            <div class="card-body text-center p-4">
                                <div class="mb-3 text-primary"><i class="fas fa-eye fa-3x"></i></div>
                                <h3 class="card-title">Vizyonumuz</h3>
                                <p class="card-text text-muted">
                                    <asp:Label ID="lblVizyon" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card h-100 shadow-sm border-0 bg-light">
                            <div class="card-body text-center p-4">
                                <div class="mb-3 text-danger"><i class="fas fa-bullseye fa-3x"></i></div>
                                <h3 class="card-title">Misyonumuz</h3>
                                <p class="card-text text-muted">
                                    <asp:Label ID="lblMisyon" runat="server"></asp:Label>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>