<%@ Page Title="Ürünler" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Urunler.aspx.cs" Inherits="MarketETicaret.Urunler" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Ürünler</h2>

    <!-- Kategori veya Arama Başlığı -->
    <h4 id="lblBaslik" runat="server"></h4>

    <!-- Ürün Kartları -->
    <div class="row" id="urunKartiContainer" runat="server">
        <!-- Ürünler buraya eklenecek -->
    </div>
</asp:Content>
