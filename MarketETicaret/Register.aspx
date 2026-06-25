<%@ Page Title="Kayıt Ol" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="MarketETicaret.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-success text-white text-center py-4">
                        <h3><i class="fas fa-user-plus me-2"></i>Aramıza Katıl</h3>
                    </div>
                    <div class="card-body p-5">
                        
                         <asp:Panel ID="pnlMesaj" runat="server" Visible="false" CssClass="alert alert-info">
                            <asp:Label ID="lblMesaj" runat="server"></asp:Label>
                        </asp:Panel>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <asp:TextBox ID="txtAd" runat="server" CssClass="form-control" placeholder="Ad"></asp:TextBox>
                                    <label>Ad</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <asp:TextBox ID="txtSoyad" runat="server" CssClass="form-control" placeholder="Soyad"></asp:TextBox>
                                    <label>Soyad</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" TextMode="Email"></asp:TextBox>
                            <label>E-Posta Adresi</label>
                        </div>

                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control" placeholder="Telefon"></asp:TextBox>
                            <label>Telefon (5XX...)</label>
                        </div>

                        <div class="form-floating mb-3">
                            <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control" placeholder="Şifre" TextMode="Password"></asp:TextBox>
                            <label>Şifre</label>
                        </div>

                        <div class="d-grid gap-2 mt-4">
                            <asp:Button ID="btnKayitOl" runat="server" Text="Kayıt Ol" CssClass="btn btn-success btn-lg" OnClick="btnKayitOl_Click" />
                        </div>

                         <div class="text-center mt-3">
                            <a href="Login.aspx" class="text-decoration-none">Zaten üye misin? Giriş Yap</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>