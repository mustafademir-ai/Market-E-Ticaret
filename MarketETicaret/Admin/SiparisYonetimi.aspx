<%@ Page Title="Sipariş Yönetimi" Language="C#" MasterPageFile="~/Admin/AdminMaster.master" AutoEventWireup="true" CodeBehind="SiparisYonetimi.aspx.cs" Inherits="MarketETicaret.Admin.SiparisYonetimi" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">



    <asp:Panel ID="pnlListe" runat="server">

        <div class="d-flex justify-content-between align-items-center mb-4">

            <h2 class="text-gray-800"><i class="fas fa-shipping-fast me-2"></i>Sipariş Yönetimi</h2>

            <asp:Button ID="btnYeniEkle" runat="server" Text="+ Yeni Sipariş Oluştur" CssClass="btn btn-success shadow-sm" OnClick="btnYeniEkle_Click" />

        </div>



        <div class="card shadow mb-4 border-left-primary">

            <div class="card-body">

                <div class="row">

                    <div class="col-md-8">

                        <div class="input-group">

                            <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>

                            <asp:TextBox ID="txtAra" runat="server" CssClass="form-control border-start-0" placeholder="Sipariş No veya Müşteri Adı ile ara..."></asp:TextBox>

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

                

                <asp:GridView ID="gridSiparisler" runat="server" AutoGenerateColumns="False" 

                    CssClass="table table-bordered table-hover align-middle" 

                    DataKeyNames="SiparisID" OnRowCommand="gridSiparisler_RowCommand">

                    

                    <Columns>

                        <asp:BoundField DataField="SiparisID" HeaderText="Sipariş No" ItemStyle-Width="100px" ItemStyle-Font-Bold="true" />

                        

                        <asp:TemplateField HeaderText="Müşteri">

                            <ItemTemplate>

                                <i class="fas fa-user text-muted me-1"></i> <%# Eval("MusteriAdi") %>

                            </ItemTemplate>

                        </asp:TemplateField>



                        <asp:BoundField DataField="SiparisTarihi" HeaderText="Tarih" DataFormatString="{0:dd.MM.yyyy HH:mm}" />

                        <asp:BoundField DataField="ToplamTutar" HeaderText="Tutar" DataFormatString="{0:C}" ItemStyle-CssClass="text-success fw-bold" />

                        

                        <asp:TemplateField HeaderText="Durum">

                            <ItemTemplate>

                                <span class='badge bg-<%# DurumRengi(Eval("SiparisDurumu").ToString()) %> p-2'>

                                    <%# Eval("SiparisDurumu") %>

                                </span>

                            </ItemTemplate>

                        </asp:TemplateField>



                        <asp:TemplateField HeaderText="İşlemler" ItemStyle-Width="180px" ItemStyle-CssClass="text-center">

                            <ItemTemplate>

                                <asp:LinkButton ID="btnDuzenle" runat="server" CommandName="Duzenle" CommandArgument='<%# Eval("SiparisID") %>' CssClass="btn btn-primary btn-sm me-1">

                                    <i class="fas fa-edit"></i> Düzenle

                                </asp:LinkButton>

                                <asp:LinkButton ID="btnSil" runat="server" CommandName="Sil" CommandArgument='<%# Eval("SiparisID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('DİKKAT: Bu siparişi ve bağlı tüm ödemeleri silmek istediğinize emin misiniz?');">

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

                            <asp:Label ID="lblFormBaslik" runat="server" Text="Sipariş İşlemleri"></asp:Label>

                        </h5>

                    </div>

                    <div class="card-body">

                        

                        <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3"></asp:Label>



                        <div class="mb-3">

                            <label class="form-label fw-bold">Müşteri Seçimi</label>

                            <asp:DropDownList ID="ddlMusteri" runat="server" CssClass="form-select"></asp:DropDownList>

                        </div>



                        <div class="row">

                            <div class="col-md-6 mb-3">

                                <label class="form-label fw-bold">Toplam Tutar (₺)</label>

                                <asp:TextBox ID="txtTutar" runat="server" CssClass="form-control" TextMode="Number" step="0.01"></asp:TextBox>

                            </div>

                            <div class="col-md-6 mb-3">

                                <label class="form-label fw-bold">Sipariş Durumu</label>

                                <asp:DropDownList ID="ddlDurum" runat="server" CssClass="form-select">

                                    <asp:ListItem Value="Onaylandı">Onaylandı</asp:ListItem>

                                    <asp:ListItem Value="Hazırlanıyor">Hazırlanıyor</asp:ListItem>

                                    <asp:ListItem Value="Kargolandı">Kargolandı</asp:ListItem>

                                    <asp:ListItem Value="Teslim Edildi">Teslim Edildi</asp:ListItem>

                                    <asp:ListItem Value="İptal">İptal</asp:ListItem>

                                    <asp:ListItem Value="Beklemede">Beklemede</asp:ListItem>

                                </asp:DropDownList>

                            </div>

                        </div>



                        <div class="alert alert-info small">

                            <i class="fas fa-info-circle me-1"></i> Not: Manuel sipariş oluştururken detaylı ürün girişi yapılmaz, sadece toplam tutar ve durum girilir.

                        </div>



                        <div class="d-flex justify-content-end border-top pt-3">

                            <asp:Button ID="btnVazgec" runat="server" Text="Vazgeç" CssClass="btn btn-secondary me-2" OnClick="btnVazgec_Click" CausesValidation="false" />

                            <asp:Button ID="btnKaydet" runat="server" Text="Kaydet" CssClass="btn btn-success px-4" OnClick="btnKaydet_Click" />

                        </div>



                    </div>

                </div>

            </div>

        </div>

    </asp:Panel>



</asp:Content> 