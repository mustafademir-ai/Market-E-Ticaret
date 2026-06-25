# 🛒 Market E-Ticaret Projesi

Bu proje, ASP.NET Web Forms ve C# kullanılarak geliştirilmiş, dinamik bir market e-ticaret web uygulamasıdır. Proje kapsamında kullanıcıların ürünleri inceleyebileceği, kategorilere göre filtreleme yapabileceği ve alışveriş süreçlerini deneyimleyebileceği bir altyapı sunulmaktadır.

## 🚀 Özellikler
- **Dinamik Kategori Sistemi:** Veri tabanından çekilen süt, tereyağı, peynir gibi çeşitli şarküteri ve market kategorileri.
- **Ürün Yönetimi:** Ürünlerin fiyat, stok ve detay bilgileriyle birlikte listelenmesi.
- **SQL Veri Tabanı Entegrasyonu:** Güçlü ve ilişkisel bir veri tabanı mimarisi.

## 🛠️ Kullanılan Teknolojiler
- **Backend:** C# / ASP.NET Web Forms
- **Frontend:** HTML5, CSS3, Bootstrap
- **Veri Tabanı:** Microsoft SQL Server (MSSQL)
- **Versiyon Kontrolü:** Git / GitHub

## 📁 Proje Yapısı
- `MarketETicaret/`: Web sayfalarının (`.aspx`), arayüz tasarımlarının ve backend kodlarının (`.cs`) bulunduğu ana uygulama klasörü.
- `database/`: Projenin veri tabanı tablolarını ve örnek verilerini içeren oluşturulma betiği (`veritabani.sql`).

## ⚙️ Kurulum ve Çalıştırma
Projeyi yerel bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

1. **Projeyi İndirin:** Bu depoyu bilgisayarınıza klonlayın veya ZIP olarak indirin.
2. **Veri Tabanını Hazırlayın:** - SQL Server Management Studio (SSMS) programını açın.
   - `database/veritabani.sql` dosyasındaki script'i çalıştırarak (Execute) veri tabanını ve tabloları otomatik oluşturun.
3. **Projeyi Açın:** Visual Studio üzerinden `MarketETicaret.sln` dosyasını çift tıklayarak projeyi yükleyin.
4. **Bağlantı Dizesini Güncelleyin:** `Web.config` dosyasındaki SQL Server bağlantı adresini (`Connection String`) kendi yerel SQL Server bilgilerinizle güncelleyin.
5. **Çalıştırın:** `F5` tuşuna basarak projeyi tarayıcıda ayağa kaldırın.
