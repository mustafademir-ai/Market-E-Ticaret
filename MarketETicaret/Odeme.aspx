<%@ Page Title="Ödeme Yap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Odeme.aspx.cs" Inherits="MarketETicaret.Odeme" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="row">
            
            <div class="col-md-8">
                
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-map-marker-alt me-2"></i> Teslimat Adresi
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Adres Başlığı (Ev/İş)</label>
                                <asp:TextBox ID="txtAdresBaslik" runat="server" CssClass="form-control" placeholder="Örn: Ev Adresim"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Şehir</label>
                                <asp:TextBox ID="txtSehir" runat="server" CssClass="form-control" placeholder="İstanbul"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">İlçe</label>
                                <asp:TextBox ID="txtIlce" runat="server" CssClass="form-control" placeholder="Kadıköy"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Posta Kodu</label>
                                <asp:TextBox ID="txtPostaKodu" runat="server" CssClass="form-control" placeholder="34000"></asp:TextBox>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Açık Adres</label>
                            <asp:TextBox ID="txtAcikAdres" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Mahalle, Sokak, Kapı No..."></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-success text-white">
                        <i class="fas fa-credit-card me-2"></i> Ödeme Yöntemi
                    </div>
                    <div class="card-body">
                        <div class="form-check mb-3">
                            <input type="radio" checked="checked" name="Odeme" class="form-check-input" />
                            <label class="form-check-label fw-bold">Kredi Kartı</label>
                            
                            <div class="mt-2 p-3 bg-light border rounded">
                                <div class="row">
                                    <div class="col-md-6 mb-2">
                                        <input type="text" class="form-control" placeholder="Kart Numarası" maxlength="16">
                                    </div>
                                    <div class="col-md-3 mb-2">
                                        <input type="text" class="form-control" placeholder="AA/YY" maxlength="5">
                                    </div>
                                    <div class="col-md-3 mb-2">
                                        <input type="text" class="form-control" placeholder="CVC" maxlength="3">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-check">
                            <input type="radio" name="Odeme" class="form-check-input" />
                            <label class="form-check-label fw-bold">Kapıda Ödeme</label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-dark text-white text-center">
                        <h4>Sipariş Özeti</h4>
                    </div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush mb-3">
                            <asp:Repeater ID="rptOzet" runat="server">
                                <ItemTemplate>
                                    <li class="list-group-item d-flex justify-content-between lh-sm">
                                        <div>
                                            <h6 class="my-0"><%# Eval("UrunAdi") %></h6>
                                            <small class="text-muted"><%# Eval("Adet") %> Adet</small>
                                        </div>
                                        <span class="text-muted"><%# Eval("ToplamFiyat", "{0:C}") %></span>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                            
                            <li class="list-group-item d-flex justify-content-between bg-light">
                                <span class="fw-bold">Toplam Tutar</span>
                                <strong class="text-success"><asp:Label ID="lblOdenecekTutar" runat="server"></asp:Label></strong>
                            </li>
                        </ul>

                        <div class="d-grid">
                            <asp:Button ID="btnSiparisiTamamla" runat="server" Text="Siparişi Onayla ve Bitir" 
                                CssClass="btn btn-primary btn-lg py-3" OnClick="btnSiparisiTamamla_Click" />
                        </div>
                        <div class="mt-2 text-center text-muted small">
                            <i class="fas fa-lock"></i> Ödemeniz 256-bit SSL ile korunmaktadır.
                        </div>
                        
                        <asp:Label ID="lblHata" runat="server" CssClass="text-danger mt-2 d-block text-center fw-bold"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>