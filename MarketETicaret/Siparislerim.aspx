<%@ Page Title="Siparişlerim" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Siparislerim.aspx.cs" Inherits="MarketETicaret.Siparislerim" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5 mb-5">
        <h2 class="mb-4"><i class="fas fa-box-open me-2"></i>Geçmiş Siparişlerim</h2>

        <asp:Panel ID="pnlSiparisYok" runat="server" Visible="false">
            <div class="alert alert-warning text-center p-4">
                <h4>Henüz bir siparişiniz bulunmuyor.</h4>
                <p>Hemen alışverişe başlayıp ilk siparişinizi oluşturabilirsiniz.</p>
                <a href="Default.aspx" class="btn btn-primary mt-2">Alışverişe Başla</a>
            </div>
        </asp:Panel>

        <div class="accordion" id="accordionSiparisler">
            <asp:Repeater ID="rptSiparisler" runat="server" OnItemDataBound="rptSiparisler_ItemDataBound">
                <ItemTemplate>
                    
                    <div class="accordion-item mb-3 border shadow-sm rounded">
                        <h2 class="accordion-header" id='heading<%# Eval("SiparisID") %>'>
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" 
                                    data-bs-target='#collapse<%# Eval("SiparisID") %>' aria-expanded="false">
                                
                                <div class="d-flex w-100 justify-content-between align-items-center me-3">
                                    <span>
                                        <strong>Sipariş No:</strong> #<%# Eval("SiparisID") %> 
                                        <span class="text-muted ms-2"> | <%# Eval("SiparisTarihi", "{0:d MMMM yyyy HH:mm}") %></span>
                                    </span>
                                    
                                    <span>
                                        <span class="badge bg-secondary me-2"><%# Eval("SiparisDurumu") %></span>
                                        <span class="text-success fw-bold"><%# Eval("ToplamTutar", "{0:C}") %></span>
                                    </span>
                                </div>

                            </button>
                        </h2>
                        
                        <div id='collapse<%# Eval("SiparisID") %>' class="accordion-collapse collapse" 
                             data-bs-parent="#accordionSiparisler">
                            <div class="accordion-body bg-light">
                                
                                <table class="table table-sm table-bordered bg-white">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Ürün Resmi</th>
                                            <th>Ürün Adı</th>
                                            <th>Birim Fiyat</th>
                                            <th>Adet</th>
                                            <th>Toplam</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptDetaylar" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td style="width: 60px;">
                                                        <img src='<%# Eval("ResimYolu") %>' width="50" height="50" style="object-fit:cover; border-radius:5px;" />
                                                    </td>
                                                    <td><%# Eval("UrunAdi") %></td>
                                                    <td><%# Eval("BirimFiyat", "{0:C}") %></td>
                                                    <td><%# Eval("Adet") %></td>
                                                    <td class="fw-bold"><%# Eval("SatirToplami", "{0:C}") %></td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>

                                <div class="text-end">
                                    <small class="text-muted">Teslimat Adresi: <%# Eval("AdresBaslik") %></small>
                                </div>

                            </div>
                        </div>
                    </div>

                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>