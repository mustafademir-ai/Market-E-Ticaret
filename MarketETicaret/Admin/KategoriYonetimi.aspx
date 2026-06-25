<%@ Page Title="Kategori Yönetimi" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="KategoriYonetimi.aspx.cs" Inherits="MarketETicaret.Admin.KategoriYonetimi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlListe" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-gray-800"><i class="fas fa-list-ul me-2"></i>Kategori Yönetimi</h2>
            <asp:Button ID="btnYeniEkle" runat="server" Text="+ Yeni Kategori Ekle" CssClass="btn btn-success shadow-sm" OnClick="btnYeniEkle_Click" />
        </div>

        <div class="card shadow mb-4 border-left-primary">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                            <asp:TextBox ID="txtAra" runat="server" CssClass="form-control border-start-0" placeholder="Kategori adı ile ara..."></asp:TextBox>
                            <asp:Button ID="btnAra" runat="server" Text="Ara" CssClass="btn btn-primary" OnClick="btnAra_Click" />
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <asp:Button ID="btnTemizle" runat="server" Text="Listeyi Sıfırla" CssClass="btn btn-secondary" OnClick="btnTemizle_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow">
            <div class="card-body table-responsive">
                <asp:Label ID="lblListeMesaj" runat="server"></asp:Label>
                
                <asp:GridView ID="gridKategoriler" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-bordered table-hover align-middle" 
                    DataKeyNames="KategoriID" OnRowCommand="gridKategoriler_RowCommand">
                    
                    <Columns>
                        <asp:BoundField DataField="KategoriID" HeaderText="ID" ItemStyle-Width="50px" />
                        
                        <asp:TemplateField HeaderText="Kategori Adı">
                            <ItemTemplate>
                                <span class="fw-bold text-primary"><%# Eval("KategoriAdi") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="180px" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDuzenle" runat="server" CommandName="Duzenle" CommandArgument='<%# Eval("KategoriID") %>' CssClass="btn btn-primary btn-sm me-1">
                                    <i class="fas fa-edit"></i> Düzenle
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnSil" runat="server" CommandName="Sil" CommandArgument='<%# Eval("KategoriID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bu kategoriyi silmek istediğinize emin misiniz?');">
                                    <i class="fas fa-trash"></i> Sil
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-4 text-muted">Kayıt bulunamadı.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server" Visible="false">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow border-top-primary">
                    <div class="card-header bg-white py-3">
                        <h5 class="m-0 font-weight-bold text-primary">
                            <asp:Label ID="lblFormBaslik" runat="server" Text="Kategori Ekle / Düzenle"></asp:Label>
                        </h5>
                    </div>
                    <div class="card-body">
                        
                        <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3"></asp:Label>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Kategori Adı</label>
                            <asp:TextBox ID="txtKategoriAdi" runat="server" CssClass="form-control" placeholder="Örn: Elektronik"></asp:TextBox>
                        </div>

                        <div class="d-flex justify-content-end border-top pt-3">
                            <asp:Button ID="btnVazgec" runat="server" Text="Vazgeç" CssClass="btn btn-secondary me-2" OnClick="btnVazgec_Click" />
                            <asp:Button ID="btnKaydet" runat="server" Text="Kaydet" CssClass="btn btn-success px-4" OnClick="btnKaydet_Click" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>

</asp:Content>