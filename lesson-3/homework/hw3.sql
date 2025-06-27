/*
BULK INSERT haqida (SQL Serverda)

Ta'rif

BULK INSERT - bu SQL Serverdagi Transact-SQL buyrug'i bo'lib, ma'lumotlar faylidan to'g'ridan-to'g'ri ma'lumotlar bazasi jadvaliga yoki ko'rinishiga tez va samarali tarzda ma'lumot yuklash imkonini beradi.

Maqsadi

BULK INSERTning asosiy maqsadlari:

	1.Tez ma'lumot yuklash: Katta hajmdagi ma'lumotlarni minimal log orqali tez yuklash uchun mo'ljallangan.

	2.To'g'ridan-to'g'ri fayldan jadvalga o'tkazish: Ma'lumotlarni oraliq bosqichlarsiz to'g'ridan-to'g'ri fayldan SQL Server jadvaliga ko'chiradi.

	3.Moslashuvchan formatlar: CSV, fixed-width va SQL Serverning o'z formatlarini qo'llab-quvvatlaydi.

	4.Kam resurs sarflashi: Bitta-bitta INSERT buyruqlariga yoki mijoz tomonidagi yuklash usullariga qaraganda samaraliroq.

Asosiy sintaksis

BULK INSERT maqsad_jadval
FROM 'fayl_manzili'
WITH (
    [qo'shimcha_parametrlar]
);

Qo'llaniladigan holatlar

	Boshqa tizimlardan eksport qilingan CSV yoki tekst fayllardan ma'lumot yuklash

	Tashqi manbalardan davriy ma'lumot import qilish

	Katta jadvallarni dastlabki ma'lumotlar bilan to'ldirish

	Ma'lumotlarni ko'chirish (migratsiya qilish)

Afzalliklari

	Katta ma'lumotlar to'plami uchun oddiy INSERT ga qaraganda tezroq

	Kamroq tarmoq trafigi (jarayon serverda bajariladi)

	Import jarayonini boshqarish uchun ko'p parametrlar

	Juda katta fayllarni samarali ishlay oladi

BULK INSERT buyrug'i ayniqsa ma'lumot omborlari, ETL jarayonlari va muntazam ravishda katta hajmdagi ma'lumotlarni yuklashni talab qiladigan holatlar uchun juda qimmatlidir.
*/



/*
SQL Serverga Yuklanishi Mumkin Bo'lgan 4 Fayl Formati

SQL Serverga quyidagi 4 turdagi fayl formatlarini yuklash mumkin:

1. CSV (Vergul bilan Ajratilgan Fayllar)

	Ma'lumotlar vergul (,) bilan ajratilgan oddiy tekst fayl

	Misol:

	ID,Ismi,Yoshi
	1,Anvar,28
	2,Dilfuza,25

	BULK INSERT bilan FIELDTERMINATOR = ',' parametri orqali yuklanadi

2. Tekst (TXT) / Aniq Kenglikdagi Format

	Ma'lumotlar belgilangan kenglikdagi ustunlarda joylashgan

	Misol:

	ID  Ismi    Yoshi
	1   Anvar   28
	2   Dilfuza 25

	FORMATFILE parametri yordamida yuklanadi

3. SQL Serverning Mahalliy BCP Formati

	SQL Server uchun maxsus optimallashtirilgan ikkilik format

	BCP yordam dasturi orqali yaratiladi

	Eng tez yuklash imkonini beradi

4. JSON Formati

To'g'ridan-to'g'ri BULK INSERT bilan emas, balki:

	OPENJSON funksiyasi (SQL Server 2016+)

	Bir ustunga yuklab, keyin JSONni tahlil qilish

Qo'shimcha Formatlar:

	Excel (XLS/XLSX) - SSIS yoki OPENROWSET kerak

	XML - OPENXML yoki XQuery orqali yuklanadi

Eng tez yuklash uchun CSV va BCP formatlari eng qulay hisoblanadi.
*/



CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
)

INSERT INTO Products
VALUES 
    (7, 'Televizor', 799.99),
    (8, 'Konditsioner', 599.99),
    (9, 'Muzlatgich', 899.99)



/*
# NULL va NOT NULL Farqi 

## NULL - Bo'sh Qiymat
**NULL** - bu jadval ustunida qiymat mavjud emasligini bildiradi. Bu:

1. **Bo'sh yoki noma'lum ma'lumot** uchun ishlatiladi
2. **0 yoki bo'sh matn ("") emas** - bu alohida holat
3. **Misollar**:
   - Mijozning telefon raqami kiritilmagan
   - Mahsulotning chegirma narxi belgilanmagan
   - Xodimning ishga kirish sanasi hali ma'lum emas

## NOT NULL - Majburiy Qiymat
**NOT NULL** - bu ustunga qiymat kiritish majburiy ekanligini anglatadi:

1. **Har doim qiymat bo'lishi kerak**
2. Agar qiymat kiritilmasa, xatolik yuzaga keladi
3. **Misollar**:
   - Mahsulot ID raqami (har doim bo'lishi kerak)
   - Foydalanuvchi logini (bo'sh qoldirib bo'lmaydi)
   - Buyurtma sanasi (avtomatik ravishda hozirgi sana qo'yilishi mumkin)

## Asosiy Farqlar

| Xususiyat        | NULL                              | NOT NULL                          |
|------------------|-----------------------------------|-----------------------------------|
| Qiymat majburiy  | Yo'q - bo'sh qoldirish mumkin     | Ha - qiymat kiritish shart        |
| Ma'nosi          | Ma'lumot yo'q/aniqlanmagan        | Doim qiymat bo'lishi kerak        |
| SQL misol        | `Phone VARCHAR(20) NULL`          | `Username VARCHAR(50) NOT NULL`   |
| Standart holat   | Agar ko'rsatilmasa, NULL hisoblanadi | Majburiy ravishda ko'rsatilishi kerak |

## Muhim Maslahatlar
1. **Asosiy kalitlar** har doim NOT NULL bo'lishi kerak
2. **Mantiqiy jihatdan majburiy bo'lmagan maydonlar** uchun NULL ruxsat etish yaxshi amaliyotdir
3. **Dastur mantig'i** - ba'zi maydonlarni boshlang'ichda bo'sh qoldirish kerak bo'lishi mumkin

**Diqqat**: NULL qiymatlar bilan ishlashda `WHERE column = NULL` emas, `WHERE column IS NULL` deb yozish kerak!
*/



ALTER TABLE Products
ADD CONSTRAINT UQ_Products_ProductName UNIQUE (ProductName);



/*
# SQL So'roviga Izoh Yozish (O'zbek Tilida)

SQL so'rovlariga izoh yozish uchun ikki xil usul mavjud:

## 1. Bir Qatorli Izoh (-- bilan boshlanadi)


-- Bu so'rov Products jadvaliga yangi mahsulot qo'shadi
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (12, 'Aqlli Telefon', 599.99);
```

## 2. Ko'p Qatorli Izoh (/* va */ orasida)


/*
Bu so'rov Products jadvalidagi barcha mahsulotlarni chiqaradi
va quyidagi ma'lumotlarni ko'rsatadi:
- Mahsulot ID raqami
- Mahsulot nomi
- Mahsulot narxi
*/
SELECT ProductID, ProductName, Price 
FROM Products;
```

## Misollar va Ularning Ma'nolari:

1. Jadval yaratishda izoh:
```sql
-- Foydalanuvchilar jadvalini yaratish
-- Bu jadval sayt foydalanuvchilari haqida ma'lumotni saqlaydi
CREATE TABLE Foydalanuvchilar (
    FoydalanuvchiID INT PRIMARY KEY,
    Ismi VARCHAR(50) NOT NULL,
    Familiya VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE
);
```

2. Ma'lumot qidirishda izoh:

/* 
Narxi 500 dan yuqori bo'lgan mahsulotlarni topish
va ularni narx bo'yicha kamayish tartibida saralash
*/
SELECT ProductName, Price
FROM Products
WHERE Price > 500
ORDER BY Price DESC;
```

3. Yangilash (UPDATE) so'rovida izoh:

-- ID raqami 5 bo'lgan mahsulot narxini yangilash
-- Chegirma kampaniyasi doirasida narx 10% ga kamaytirildi
UPDATE Products
SET Price = Price * 0.9
WHERE ProductID = 5;
```

Izohlar yozishning afzalliklari:
1. Kodni tushunishni osonlashtiradi
2. Kelajakda o'zgartirish kiritishda yordam beradi
3. Jamoa a'zolariga kodning maqsadini tushuntiradi
4. Muhim cheklovlar va biznes qoidalarini eslatib turadi

Eslatma: Izohlar faqat insonlar uchun mo'ljallangan, SQL server tomonidan bajarilmaydi.
*/



ALTER TABLE Products
ADD CategoryID INT;

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE



/*
	# SQL Serverda IDENTITY Ustunining Maqsadi 

## IDENTITY Nima?

**IDENTITY** - bu SQL Serverda avtomatik ravishda raqamlash (auto-increment) xususiyatidir. U asosan jadvallarning asosiy kalit (primary key) ustunida qo'llaniladi.

## Asosiy Maqsadlari:

1. **Avtomatik Raqamlash**:
   - Har bir yangi yozuv (record) qo'shilganda, avtomatik yangi raqam yaratadi
   - Dasturchiga har safar yangi ID o'ylab topish shart emas

2. **Yagona Identifikator**:
   - Har bir yozuvga yagona (unique) raqam beradi
   - Jadvaldagi ma'lumotlarni aniq tanib olish uchun ishlatiladi

3. **Samaradorlik**:
   - Ma'lumotlar bazasi tomonidan optimallashtirilgan
   - Bir vaqtning o'zida ko'p foydalanuvchilar qo'shsa ham, raqamlar takrorlanmaydi

## Qanday Ishlaydi?

```sql
CREATE TABLE Mijozlar (
    MijozID INT IDENTITY(1,1) PRIMARY KEY,
    Ismi VARCHAR(50),
    Familiya VARCHAR(50)
)
```

Bu misolda:
- `IDENTITY(1,1)` - 1 dan boshlab, har qo'shilganda 1 ga oshadi
- Birinchi raqam - boshlang'ich qiymat
- Ikkinchi raqam - qadam (increment) miqdori

## Misol:

```sql
INSERT INTO Mijozlar (Ismi, Familiya) VALUES ('Ali', 'Valiyev')
INSERT INTO Mijozlar (Ismi, Familiya) VALUES ('Gulnora', 'Rasulova')
```

Natija:

| MijozID | Ismi    | Familiya  |
|---------|---------|-----------|
| 1       | Ali     | Valiyev   |
| 2       | Gulnora | Rasulova  |

## Muhim Nuqtalar:

1. **Faqat bitta ustunga qo'llash mumkin** - har bir jadvalda faqat bitta IDENTITY ustun bo'lishi mumkin

2. **O'zgartirish cheklovlari**:
   - Odatiy holatda IDENTITY qiymatini o'zgartirib bo'lmaydi
   - Agar o'zgartirish kerak bo'lsa, `SET IDENTITY_INSERT ON` buyrug'idan foydalanish kerak

3. **Gapirlar**:
   - Agar yozuv o'chirilsa, o'sha raqam qayta ishlatilmaydi
   - Server qayta ishga tushganda, raqamlashda uzilish bo'lishi mumkin

IDENTITY xususiyati ayniqsa foydalanuvchilar, buyurtmalar, mahsulotlar kabi jadvallarda qulay bo'lib, ularga yagona identifikator berish uchun ishlatiladi.
*/



BULK INSERT Products
FROM 'C:\temp\products_data.txt'
WITH (
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
);

ALTER TABLE Products
ADD CONSTRAINT fk_category
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID);


select * from products

select * from Categories

INSERT INTO Categories (CategoryID, CategoryName)
VALUES 
(1, 'Elektronika'),
(2, 'Maishiy texnika'),
(3, 'Kitoblar');



/*
## 🧩 PRIMARY KEY va UNIQUE KEY o‘rtasidagi asosiy farqlar:

| # | PRIMARY KEY                                  | UNIQUE KEY                                                              |
| - | -------------------------------------------- | ----------------------------------------------------------------------- |
| 1 | Har bir jadvalda **faqat bitta** bo‘ladi     | Jadvalda **bir nechta** bo‘lishi mumkin                                 |
| 2 | `NULL` qiymatga **ruxsat bermaydi**          | `NULL` qiymatga **ruxsat beradi** (1 marta)                             |
| 3 | Avtomatik **UNIQUE** va **NOT NULL** bo‘ladi | Faqat **UNIQUE**; NOT NULL bo‘lmasa ham bo‘ladi                         |
| 4 | Odatda jadvaldagi asosiy identifikator       | Odatda boshqa ustunlar uchun cheklov (masalan, telefon raqam, passport) |
| 5 | Sintaksisi: `PRIMARY KEY (ustun)`            | Sintaksisi: `UNIQUE (ustun)`                                            |

---

## 📌 Tushunarli qilib misol bilan:

### 🎯 PRIMARY KEY:

```sql
CREATE TABLE Talabalar (
    StudentID INT PRIMARY KEY,      -- Har bir talabaga noyob ID beriladi
    Ism NVARCHAR(100),
    Yil INT
);
```

> Bu yerda `StudentID` ustunida **takrorlanadigan yoki NULL qiymat** bo‘lishi **mumkin emas**. Har bir talabaning yagona ID raqami bo‘ladi.

---

### 🎯 UNIQUE KEY:

```sql
CREATE TABLE Talabalar (
    StudentID INT PRIMARY KEY,
    PassportNumber NVARCHAR(20) UNIQUE   -- Har kimning passport raqami boshqalarnikidan farq qiladi
);
```

> Bu yerda `PassportNumber` ustunida **takrorlangan qiymat bo‘lmaydi**, lekin **`NULL` qiymat bo‘lishi mumkin** (ayniqsa agar passport raqam hali berilmagan bo‘lsa).

---

## 🟢 Qisqacha xulosa:

* `PRIMARY KEY` — jadvalning **asosiy noyob identifikatori**.
* `UNIQUE KEY` — boshqa ustunlar uchun **noyoblikni ta’minlash** vositasi.
* `PRIMARY KEY` har doim **1 dona** bo‘ladi, `UNIQUE` esa **bir nechta bo‘lishi** mumkin.
* `PRIMARY KEY` — **NULL bo‘lmaydi**, `UNIQUE` — **NULL bo‘lishi mumkin (bir marta)**.
*/




ALTER TABLE Products
ADD CONSTRAINT chk_price_positive
CHECK (Price > 0);

ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;
 
UPDATE Products
SET Price = 0
WHERE Price IS NULL;



/*

## 🔑 FOREIGN KEY nima?

**FOREIGN KEY** — bu bitta jadvaldagi ustun boshqa bir jadvaldagi ustun bilan **bog‘liq** bo‘lishini ta’minlovchi **cheklov (constraint)**.

> Ya’ni, bu boshqa jadvaldagi ma’lumotga **isora qiluvchi kalit**.

---

## 🎯 Maqsadi (Purpose):

1. 🔒 **Ma’lumotlar yaxlitligini (integrity)** saqlash.

   * Foydalanuvchi noto‘g‘ri yoki mavjud bo‘lmagan qiymatni yozishining oldini oladi.
2. 🔗 **Jadvallar orasidagi bog‘liqlikni** ko‘rsatadi.

   * Masalan, mahsulotning qaysi kategoriya, foydalanuvchining qaysi rollar jadvalidagi rolga tegishli ekanini.

---

## 🧱 Tuzilishi (Umumiy sintaksis):

```sql
ALTER TABLE JadvalNomi
ADD CONSTRAINT TashqiKalitNomi
FOREIGN KEY (UstunNomi)
REFERENCES BoglanayotganJadval(BoglanadiganUstun);
```

---

## 🧾 Misol bilan tushuntirish:

### 🔧 1. `Categories` jadvali:

```sql
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100)
);
```

### 🔧 2. `Products` jadvali:

```sql
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Price DECIMAL(10, 2),
    CategoryID INT,
    CONSTRAINT fk_category
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID)
);
```

> Bu yerda `Products.CategoryID` ustuni **`Categories.CategoryID` ustuniga bog‘langan**.

---

## ⚠️ Nimalardan himoya qiladi?

* Kategoriya jadvalida mavjud bo‘lmagan `CategoryID` ni yozishdan:

```sql
INSERT INTO Products (ProductName, Price, CategoryID)
VALUES ('Mahsulot1', 100, 999); -- ❌ Bu xatolik beradi agar 999 yo‘q bo‘lsa
```

* Kategoriya o‘chirilsa, unga tegishli mahsulotlar qanday bo‘lishi belgilanishi mumkin:

```sql
FOREIGN KEY (CategoryID)
REFERENCES Categories(CategoryID)
ON DELETE CASCADE;  -- Kategoriya o‘chirilsa, mahsulotlar ham o‘chadi
```

---

## 🧠 Xulosa:

| 🔍 Afzallik           | Tavsif                                               |
| --------------------- | ---------------------------------------------------- |
| 💾 Yaxlitlik          | Bog‘liq ma’lumotlar orasidagi moslikni saqlaydi      |
| ❌ Xatolikdan saqlaydi | Noto‘g‘ri yoki yo‘q qiymat kiritishni cheklaydi      |
| 🔗 Munosabat          | Jadvallar orasidagi real aloqani ifodalaydi          |
| 👮‍♂️ Nazorat         | Ma’lumotlar bazasida avtomatik nazoratni ta’minlaydi |

*/



CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),   -- Avtomatik ID
    FirstName NVARCHAR(100) NOT NULL,           -- Ism
    LastName NVARCHAR(100) NOT NULL,            -- Familiya
    Age INT NOT NULL,                           -- Yoshi
    CONSTRAINT chk_age_18                       -- CHECK constraint nomi
        CHECK (Age >= 18)                       -- Shart: 18 yoki undan katta bo‘lishi kerak
);

select * from Customers

-- ✅ To‘g‘ri ishlaydi:
INSERT INTO Customers (FirstName, LastName, Age)
VALUES ('Ali', 'Karimov', 25);

-- ❌ Xatolik beradi:
INSERT INTO Customers (FirstName, LastName, Age)
VALUES ('Olim', 'Tursunov', 16);

CREATE TABLE SampleTable (
    ID INT IDENTITY(100, 10) PRIMARY KEY,
    Name NVARCHAR(100)
);

select * from SampleTable

INSERT INTO SampleTable (Name) VALUES ('Ali');
INSERT INTO SampleTable (Name) VALUES ('Vali');
INSERT INTO SampleTable (Name) VALUES ('Sami');

CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT,
    Price DECIMAL(10, 2),
    CONSTRAINT pk_orderdetails PRIMARY KEY (OrderID, ProductID)
);

select * from OrderDetails



/*

## 🎯 Maqsad:

Ikkala funksiya ham **`NULL` qiymatlarni boshqasi bilan almashtirish** uchun ishlatiladi.

---

## 🧮 ISNULL() funksiyasi

### ✅ Ishlatilishi:

```sql
ISNULL(expression, replacement_value)
```

### 📌 Ma'nosi:

Agar `expression` (`NULL` bo‘lsa), u holda `replacement_value` (o‘rniga) qiymatni qaytaradi.

### 🔍 Misol:

```sql
SELECT ISNULL(NULL, 0);  -- Natija: 0
SELECT ISNULL(5, 0);     -- Natija: 5
```

### 🔧 Real misol:

```sql
SELECT ProductName, ISNULL(Price, 0) AS Price
FROM Products;
```

Agar `Price` `NULL` bo‘lsa, u holda `0` sifatida qaytariladi.

---

## 🧮 COALESCE() funksiyasi

### ✅ Ishlatilishi:

```sql
COALESCE(expression1, expression2, ..., expressionN)
```

### 📌 Ma'nosi:

Chapdan boshlab **birinchi `NULL` bo‘lmagan qiymatni** qaytaradi.

### 🔍 Misol:

```sql
SELECT COALESCE(NULL, NULL, 10, NULL, 20);  -- Natija: 10
```

### 🔧 Real misol:

```sql
SELECT CustomerName, COALESCE(Phone, Mobile, 'Noma’lum') AS ContactNumber
FROM Customers;
```

Bu yerda:

* Agar `Phone` bo‘lsa — shu qaytadi,
* bo‘lmasa `Mobile`,
* agar ikkalasi ham `NULL` bo‘lsa — `"Noma’lum"` chiqadi.

---

## 🔄 ISNULL vs COALESCE: Farqlari

| Xususiyat          | ISNULL                 | COALESCE                         |
| ------------------ | ---------------------- | -------------------------------- |
| Parametrlar soni   | Faqat **2 ta**         | **Bir nechta** (`2+`)            |
| Standart           | SQL Server’ga xos      | ANSI SQL standarti               |
| Qaytariladigan tip | Ikkinchi argument tipi | Eng yuqori **priority** dagi tip |
| Soddaligi          | Soddaroq               | Kengroq va moslashuvchan         |

---

## 🧠 Xulosa:

| Qachon ishlatish kerak?                                                                     |
| ------------------------------------------------------------------------------------------- |
| Faqat bitta `NULL`ni 1ta qiymat bilan almashtirish kerak bo‘lsa — **`ISNULL()`**            |
| Bir nechta ustunlardan birinchi mavjud qiymatni ko‘rsatmoqchi bo‘lsangiz — **`COALESCE()`** |

*/

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,                   
    FirstName NVARCHAR(100) NOT NULL,        
    LastName NVARCHAR(100) NOT NULL,         
    Email NVARCHAR(255) UNIQUE,              
    HireDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    CONSTRAINT fk_customer_order
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

DELETE FROM Customers WHERE CustomerID = 1;

UPDATE Customers SET CustomerID = 10 WHERE CustomerID = 1;


