<%@ Page Title="Hesabım" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Hesabim.aspx.cs" Inherits="MarketETicaret.Hesabim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <h2 class="mb-4 border-bottom pb-2">Hesabım</h2>
        
        <div class="row">
            <div class="col-lg-5 mb-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Bilgilerimi Güncelle</h5>
                    </div>
                    <div class="card-body">
                        
                        <%-- Durum Mesajı --%>
                        <asp:Label ID="lblMesaj" runat="server" Visible="false" CssClass="alert alert-info d-block w-100"></asp:Label>

                        <div class="mb-3">
                            <label class="form-label fw-bold">E-Posta (Değiştirilemez)</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#f8f9fa"></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Ad</label>
                                <asp:TextBox ID="txtAd" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAd" runat="server" ControlToValidate="txtAd" ErrorMessage="*" ForeColor="Red" ValidationGroup="Guncelle"></asp:RequiredFieldValidator>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Soyad</label>
                                <asp:TextBox ID="txtSoyad" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvSoyad" runat="server" ControlToValidate="txtSoyad" ErrorMessage="*" ForeColor="Red" ValidationGroup="Guncelle"></asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Telefon</label>
                            <asp:TextBox ID="txtTelefon" runat="server" CssClass="form-control" TextMode="Phone"></asp:TextBox>
                        </div>

                        <%-- ADRES KISMI KALDIRILDI (Hata Verdiği İçin) --%>

                        <hr />
                        <h6 class="text-muted mb-3">Şifre Değiştir (İsteğe Bağlı)</h6>

                        <div class="mb-2">
                            <asp:TextBox ID="txtEskiSifre" runat="server" CssClass="form-control" TextMode="Password" placeholder="Mevcut Şifreniz"></asp:TextBox>
                        </div>
                        <div class="mb-3">
                            <asp:TextBox ID="txtYeniSifre" runat="server" CssClass="form-control" TextMode="Password" placeholder="Yeni Şifre"></asp:TextBox>
                        </div>

                        <div class="d-grid">
                            <asp:Button ID="btnGuncelle" runat="server" Text="Bilgileri Güncelle" CssClass="btn btn-success" OnClick="btnGuncelle_Click" ValidationGroup="Guncelle" />
                        </div>

                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="fas fa-shopping-bag me-2"></i>Geçmiş Siparişlerim</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <asp:GridView ID="gridSiparisler" runat="server" AutoGenerateColumns="False" 
                                CssClass="table table-striped table-hover mb-0" GridLines="None"
                                EmptyDataText="Henüz bir siparişiniz bulunmamaktadır.">
                                <Columns>
                                    <asp:BoundField DataField="SiparisID" HeaderText="Sipariş No" />
                                    
                                    <asp:BoundField DataField="SiparisTarihi" HeaderText="Tarih" DataFormatString="{0:dd.MM.yyyy}" />
                                    
                                    <asp:BoundField DataField="ToplamTutar" HeaderText="Tutar" DataFormatString="{0:C}" />
                                    
                                    <%-- DURUM KOLONU KALDIRILDI (Hata Verdiği İçin) --%>
                                    <asp:TemplateField HeaderText="Durum">
                                        <ItemTemplate>
                                            <span class="badge bg-secondary">İşlemde</span>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                                <HeaderStyle CssClass="table-light" />
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>