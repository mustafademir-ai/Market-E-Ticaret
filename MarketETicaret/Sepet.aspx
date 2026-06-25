<%@ Page Title="Sepetim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sepet.aspx.cs" Inherits="MarketETicaret.Sepet" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-5">
        <h2>Alışveriş Sepetim</h2>
        <hr />

        <asp:Panel ID="pnlSepetBos" runat="server" Visible="false">
            <div class="alert alert-warning text-center">
                <h4>Sepetinizde ürün bulunmamaktadır.</h4>
                <a href="Default.aspx" class="btn btn-primary mt-3">Alışverişe Başla</a>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlSepetDolu" runat="server">
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Ürün Resmi</th>
                        <th>Ürün Adı</th>
                        <th>Fiyat</th>
                        <th>Adet</th>
                        <th>Tutar</th>
                        <th>İşlem</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptSepet" runat="server" OnItemCommand="rptSepet_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <img src='<%# Eval("Resim") %>' width="50" height="50" style="object-fit:cover;" />
                                </td>
                                <td><%# Eval("UrunAdi") %></td>
                                <td><%# Eval("Fiyat", "{0:C}") %></td>
                                <td><%# Eval("Adet") %></td>
                                <td><%# Eval("Tutar", "{0:C}") %></td>
                                <td>
                                    <asp:Button ID="btnSil" runat="server" Text="Sil" 
                                        CommandName="Sil" 
                                        CommandArgument='<%# Eval("SepetUrunID") %>' 
                                        CssClass="btn btn-danger btn-sm" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <div class="row">
                <div class="col-md-8"></div>
                <div class="col-md-4 text-end">
                    <h4>Toplam: <asp:Label ID="lblToplamTutar" runat="server" Text="0.00 ₺" ForeColor="Green"></asp:Label></h4>
                    <a href="Odeme.aspx" class="btn btn-success btn-lg mt-2">Sepeti Onayla & Öde</a>
                </div>
            </div>
        </asp:Panel>
    </div>

</asp:Content>