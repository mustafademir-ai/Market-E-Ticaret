<%@ Page Title="Müşteri Yönetimi" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="MusteriYonetimi.aspx.cs" Inherits="MarketETicaret.Admin.MusteriYonetimi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlListe" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-gray-800"><i class="fas fa-users me-2"></i>Müşteri Yönetimi</h2>
            <asp:Button ID="btnYeniEkle" runat="server" Text="+ Yeni Müşteri Ekle" CssClass="btn btn-success shadow-sm" OnClick="btnYeniEkle_Click" />
        </div>

        <div class="card shadow mb-4 border-left-primary">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                            <asp:TextBox ID="txtAra" runat="server" CssClass="form-control border-start-0" placeholder="Ad, Soyad veya E-Posta ile ara..."></asp:TextBox>
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
                <asp:GridView ID="gridMusteriler" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-bordered table-hover align-middle" 
                    DataKeyNames="MusteriID" OnRowCommand="gridMusteriler_RowCommand">
                    
                    <Columns>
                        <asp:BoundField DataField="MusteriID" HeaderText="ID" ItemStyle-Width="50px" />
                        
                        <asp:TemplateField HeaderText="Ad Soyad">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle p-2 me-2 text-primary">
                                        <i class="fas fa-user"></i>
                                    </div>
                                    <span class="fw-bold"><%# Eval("Ad") %> <%# Eval("Soyad") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Email" HeaderText="E-Posta" />
                        <asp:BoundField DataField="Telefon" HeaderText="Telefon" NullDisplayText="-" />
                        <asp:BoundField DataField="KayitTarihi" HeaderText="Kayıt Tarihi" DataFormatString="{0:dd.MM.yyyy}" />

                        <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="180px" ItemStyle-CssClass="text-center">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDuzenle" runat="server" CommandName="Duzenle" CommandArgument='<%# Eval("MusteriID") %>' CssClass="btn btn-primary btn-sm me-1">
                                    <i class="fas fa-edit"></i> Düzenle
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnSil" runat="server" CommandName="Sil" CommandArgument='<%# Eval("MusteriID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Bu müşteriyi silmek istediğinize emin misiniz?');">
                                    <i class="fas fa-trash"></i> Sil
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-4 text-muted">Kayıtlı müşteri bulunamadı.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlForm" runat="server" Visible="false">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow border-top-primary">
                    <div class="card-header bg-white py-3">
                        <h5 class="m-0 font-weight-bold text-primary">
                            <asp:Label ID="lblFormBaslik" runat="server" Text="Müşteri Ekle / Düzenle"></asp:Label>
                        </h5>
                    </div>
                    <div class="card-body">
                        
                        <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3"></asp:Label>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Ad</label>
                                <asp:TextBox ID="txtAd" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Soyad</label>
                                <asp:TextBox ID="txtSoyad" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">E-Posta Adresi</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Telefon</label>
                                <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Şifre</label>
                            <asp:TextBox ID="txtSifre" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            <small class="text-muted"><i class="fas fa-info-circle"></i> Düzenleme yaparken şifreyi değiştirmek istemiyorsanız boş bırakın.</small>
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