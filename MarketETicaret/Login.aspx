<%@ Page Title="Giriş Yap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MarketETicaret.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg border-0 rounded-lg">
                    <div class="card-header bg-primary text-white text-center py-4">
                        <h3><i class="fas fa-sign-in-alt me-2"></i>Üye Girişi</h3>
                    </div>
                    <div class="card-body p-5">
                        <asp:Panel ID="pnlHata" runat="server" Visible="false" CssClass="alert alert-danger">
                            <asp:Label ID="lblHata" runat="server"></asp:Label>
                        </asp:Panel>

                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="name@example.com" TextMode="Email"></asp:TextBox>
                            <label for="txtEmail">E-Posta Adresi</label>
                        </div>
                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control" placeholder="Şifre" TextMode="Password"></asp:TextBox>
                            <label for="txtSifre">Şifre</label>
                        </div>
                        
                        <div class="d-grid gap-2 mt-4">
                            <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap" CssClass="btn btn-primary btn-lg" OnClick="btnGiris_Click" />
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="Register.aspx" class="text-decoration-none">Hesabın yok mu? Hemen Kayıt Ol</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>