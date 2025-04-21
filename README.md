# ☕️ CoffeeShop App

CoffeeShop, Swift ile geliştirilen modern ve kullanıcı dostu bir iOS e-ticaret uygulamasıdır. Kullanıcılar ürünleri inceleyebilir, sepete ekleyebilir, favori ürünlerini yönetebilir ve sipariş geçmişlerini görüntüleyebilir.

Uygulama, MVVM mimarisi ve protocol-oriented programlama yaklaşımıyla geliştirilmiştir. SnapKit ile arayüz kurulumu yapılmış, Firebase altyapısı ile kimlik doğrulama, veri yönetimi ve güvenli kullanıcı işlemleri sağlanmıştır.

---

## 📦 Özellikler

- 🔐 **Kullanıcı Girişi & Kayıt:** Firebase Authentication ile güvenli oturum yönetimi
- 🎨 **SnapKit ile Custom UI:** Dinamik ve esnek arayüzler (CustomTextField, CustomButton, ViewCheckLabel vs.)
- 🧠 **MVVM + Protocol-Oriented Architecture:** Test edilebilir ve sürdürülebilir yapı
- 📦 **SPM ile Paket Yönetimi:** Firebase, SnapKit ve Kingfisher gibi kütüphaneler Swift Package Manager ile entegre edildi
- 🌍 **İki Dilli Destek:** Türkçe 🇹🇷 ve İngilizce 🇺🇸 dil desteği (localization)
- 🛒 **Sepet Yönetimi:** Firestore üzerinden ürün adediyle birlikte sepet sistemi
- ❤️ **Favori Ürünler:** Kullanıcıya özel favori listesi
- 🧾 **Sipariş Geçmişi:** Firestore'dan çekilen geçmiş sipariş ekranı
- 🧭 **Splash & TabBar Akışı:** Uygulama splash ekranıyla başlar, login durumu kontrol edilir ve yönlendirme yapılır

---

## 🔧 Kurulum

1. Xcode 14+ yüklü olduğundan emin olun
2. Repo’yu klonlayın:
   ```bash
   git clone https://github.com/Zackguler/CoffeeShop.git
   cd CoffeeShop

