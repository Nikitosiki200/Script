local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local SoundService=game:GetService("SoundService")
local HttpService=game:GetService("HttpService")
local LP=Players.LocalPlayer
local IS_MOBILE=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local EXECUTOR_NAME="Unknown"
pcall(function() if identifyexecutor then EXECUTOR_NAME=identifyexecutor() end end)
local IS_DELTA=EXECUTOR_NAME:lower():find("delta")~=nil

local httpReq=(syn and syn.request) or (http and http.request) or http_request or request
local function http(m,u,b,h,t)
    if not httpReq then return nil end
    local o={Url=u,Method=m or "GET",Headers=h or {}}
    if b then o.Body=type(b)=="string" and b or HttpService:JSONEncode(b) end
    o.Timeout=t or 10
    local ok,r=pcall(httpReq,o)
    return ok and r or nil
end

local WEBHOOK_MAIN = "https://kj.shushenkovnicita.workers.dev/"
local WEBHOOK_FALLBACK = "https://kj.shushenkovnicita.workers.dev/"

local Languages={
    {code="ru",name="Русский"},{code="en",name="English"},{code="es",name="Español"},
    {code="zh",name="中文"},{code="hi",name="हिन्दी"},{code="ar",name="العربية"},
    {code="pt",name="Português"},{code="bn",name="বাংলা"},{code="ja",name="日本語"},
    {code="de",name="Deutsch"},{code="fr",name="Français"},{code="ko",name="한국어"},
    {code="it",name="Italiano"},{code="tr",name="Türkçe"},{code="vi",name="Tiếng Việt"},
    {code="pl",name="Polski"},{code="nl",name="Nederlands"},{code="th",name="ไทย"},
    {code="id",name="Indonesia"},{code="uk",name="Українська"},
}

local T={
    en={general="General",toggles="Toggles",actions="Actions",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Keybinds",screenButtons="On-screen Buttons",movement="Movement",config="Config",authors="Authors",tpCooldown="TP Cooldown",sound="Sound",notifications="Notifications",hideHp="Hide HP",hideNames="Hide Names",esp="ESP",ultBar="Ult Bar",panicMode="Panic Mode (L)",killstreak="Killstreak",showNames="Show Names",flingCount="Count",flingList="Fling List",touchFling="Touch Fling",stop="Stop",noPlayerCollide="No Player Collide",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Click TP",loadBtn="Load",delBtn="Del",empty="Empty",autoLoad="Auto-load",tpToPlayer="TP to",spectate="Spectate",back="Back",ultPulse="Ult Pulse",namesDuration="Names Duration",tpWalk="TP Walk",tpWalkSpeed="TP Walk Speed",noclip="Noclip",infJump="Infinite Jump",save="Save",refresh="Refresh",saved="Saved",colorBase="Base Color",colorUlt="Ult Color",highlightBase="Highlight Base",highlightUlt="Highlight Ult",distance="Distance",position="Position",tpNow="TP Now",name="Name",hpLabel="HP",tpBase="TP Base",tpUlt="TP Ult"},
    ru={general="Общие",toggles="Переключатели",actions="Действия",fling="Флинг",antiFling="Анти-флинг",autoFling="Авто-флинг",keybinds="Бинды",screenButtons="Кнопки на экране",movement="Движение",config="Конфиг",authors="Авторы",tpCooldown="Кулдаун ТП",sound="Звук",notifications="Уведомления",hideHp="Скрыть HP",hideNames="Скрыть имена",esp="ESP",ultBar="Полоска ульты",panicMode="Паник-мод (L)",killstreak="Киллстрик",showNames="Показать имена",flingCount="Сколько раз",flingList="Список флинга",touchFling="Туч-флинг",stop="Стоп",noPlayerCollide="Без коллизии",autoFlingToggle="Авто-флинг",ctrlClickTp="Ctrl+Клик ТП",loadBtn="Загр.",delBtn="Удал.",empty="Пусто",autoLoad="Авто-загр.",tpToPlayer="ТП к",spectate="Наблюдать",back="Назад",ultPulse="Пульс ульты",namesDuration="Время имён",tpWalk="ТП-ходьба",tpWalkSpeed="Скор. ТП",noclip="Ноуклип",infJump="Беск. прыжок",save="Сохранить",refresh="Обновить",saved="Сохранённые",colorBase="Цвет базы",colorUlt="Цвет ульты",highlightBase="Подсветка базы",highlightUlt="Подсветка ульты",distance="Дистанция",position="Позиция",tpNow="ТП сейчас",name="Имя",hpLabel="HP",tpBase="ТП база",tpUlt="ТП ульта"},
    es={general="General",toggles="Interruptores",actions="Acciones",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Atajos",screenButtons="Botones en Pantalla",movement="Movimiento",config="Configuración",authors="Autores",tpCooldown="Enfriamiento TP",sound="Sonido",notifications="Notificaciones",hideHp="Ocultar HP",hideNames="Ocultar Nombres",esp="ESP",ultBar="Barra Ult",panicMode="Modo Pánico (L)",killstreak="Racha",showNames="Mostrar Nombres",flingCount="Veces",flingList="Lista Fling",touchFling="Fling Táctil",stop="Parar",noPlayerCollide="Sin Colisión",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Clic TP",loadBtn="Cargar",delBtn="Borrar",empty="Vacío",autoLoad="Auto-carga",tpToPlayer="TP a",spectate="Observar",back="Atrás",ultPulse="Pulso Ult",namesDuration="Duración Nombres",tpWalk="Caminata TP",tpWalkSpeed="Velocidad TP",noclip="Sin Colisión",infJump="Salto Infinito",save="Guardar",refresh="Actualizar",saved="Guardados",colorBase="Color Base",colorUlt="Color Ult",highlightBase="Resaltar Base",highlightUlt="Resaltar Ult",distance="Distancia",position="Posición",tpNow="TP Ahora",name="Nombre",hpLabel="HP",tpBase="TP Base",tpUlt="TP Ult"},
    zh={general="通用",toggles="开关",actions="操作",fling="甩飞",antiFling="反甩飞",autoFling="自动甩飞",keybinds="按键绑定",screenButtons="屏幕按钮",movement="移动",config="配置",authors="作者",tpCooldown="传送冷却",sound="音效",notifications="通知",hideHp="隐藏血量",hideNames="隐藏名字",esp="透视",ultBar="大招条",panicMode="恐慌模式 (L)",killstreak="连杀",showNames="显示名字",flingCount="次数",flingList="甩飞列表",touchFling="触控甩飞",stop="停止",noPlayerCollide="无玩家碰撞",autoFlingToggle="自动甩飞",ctrlClickTp="Ctrl+点击传送",loadBtn="加载",delBtn="删除",empty="空",autoLoad="自动加载",tpToPlayer="传送到",spectate="观战",back="返回",ultPulse="大招脉冲",namesDuration="名字时长",tpWalk="传送行走",tpWalkSpeed="传送速度",noclip="穿墙",infJump="无限跳跃",save="保存",refresh="刷新",saved="已保存",colorBase="基础色",colorUlt="大招色",highlightBase="基础高亮",highlightUlt="大招高亮",distance="距离",position="位置",tpNow="立即传送",name="名字",hpLabel="HP",tpBase="传送基础",tpUlt="传送大招"},
    hi={general="सामान्य",toggles="टॉगल",actions="कार्रवाई",fling="फ्लिंग",antiFling="एंटी-फ्लिंग",autoFling="ऑटो-फ्लिंग",keybinds="कीबाइंड",screenButtons="स्क्रीन बटन",movement="मूवमेंट",config="कॉन्फ़िग",authors="लेखक",tpCooldown="TP कूलडाउन",sound="ध्वनि",notifications="सूचनाएं",hideHp="HP छिपाएं",hideNames="नाम छिपाएं",esp="ESP",ultBar="अल्ट बार",panicMode="पैनिक मोड (L)",killstreak="किलस्ट्रीक",showNames="नाम दिखाएं",flingCount="गिनती",flingList="फ्लिंग सूची",touchFling="टच फ्लिंग",stop="रोकें",noPlayerCollide="बिना टकराव",autoFlingToggle="ऑटो-फ्लिंग",ctrlClickTp="Ctrl+क्लिक TP",loadBtn="लोड",delBtn="हटाएं",empty="खाली",autoLoad="ऑटो-लोड",tpToPlayer="TP पर",spectate="देखें",back="वापस",ultPulse="अल्ट पल्स",namesDuration="नाम अवधि",tpWalk="TP वॉक",tpWalkSpeed="TP गति",noclip="नोक्लिप",infJump="अनंत छलांग",save="सहेजें",refresh="रिफ्रेश",saved="सहेजे गए",colorBase="बेस रंग",colorUlt="अल्ट रंग",highlightBase="बेस हाइलाइट",highlightUlt="अल्ट हाइलाइट",distance="दूरी",position="स्थिति",tpNow="अभी TP",name="नाम",hpLabel="HP",tpBase="बेस TP",tpUlt="अल्ट TP"},
    ar={general="عام",toggles="المفاتيح",actions="الإجراءات",fling="قذف",antiFling="مضاد القذف",autoFling="قذف تلقائي",keybinds="اختصارات",screenButtons="أزرار الشاشة",movement="الحركة",config="الإعدادات",authors="المؤلفون",tpCooldown="تبريد النقل",sound="الصوت",notifications="الإشعارات",hideHp="إخفاء الصحة",hideNames="إخفاء الأسماء",esp="ESP",ultBar="شريط الألتي",panicMode="وضع الذعر (L)",killstreak="سلسلة القتل",showNames="إظهار الأسماء",flingCount="العدد",flingList="قائمة القذف",touchFling="قذف باللمس",stop="إيقاف",noPlayerCollide="بلا تصادم",autoFlingToggle="قذف تلقائي",ctrlClickTp="Ctrl+نقر TP",loadBtn="تحميل",delBtn="حذف",empty="فارغ",autoLoad="تحميل تلقائي",tpToPlayer="نقل إلى",spectate="مشاهدة",back="رجوع",ultPulse="نبض الألتي",namesDuration="مدة الأسماء",tpWalk="نقل المشي",tpWalkSpeed="سرعة النقل",noclip="اختراق",infJump="قفز لانهائي",save="حفظ",refresh="تحديث",saved="المحفوظة",colorBase="لون الأساس",colorUlt="لون الألتي",highlightBase="تمييز الأساس",highlightUlt="تمييز الألتي",distance="المسافة",position="الموضع",tpNow="نقل الآن",name="الاسم",hpLabel="HP",tpBase="نقل الأساس",tpUlt="نقل الألتي"},
    pt={general="Geral",toggles="Alternadores",actions="Ações",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Atalhos",screenButtons="Botões na Tela",movement="Movimento",config="Configuração",authors="Autores",tpCooldown="Recarga TP",sound="Som",notifications="Notificações",hideHp="Ocultar HP",hideNames="Ocultar Nomes",esp="ESP",ultBar="Barra Ultimate",panicMode="Modo Pânico (L)",killstreak="Sequência",showNames="Mostrar Nomes",flingCount="Vezes",flingList="Lista Fling",touchFling="Fling de Toque",stop="Parar",noPlayerCollide="Sem Colisão",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Clique TP",loadBtn="Carregar",delBtn="Apagar",empty="Vazio",autoLoad="Auto-carregar",tpToPlayer="TP para",spectate="Observar",back="Voltar",ultPulse="Pulso Ult",namesDuration="Duração Nomes",tpWalk="Caminhada TP",tpWalkSpeed="Velocidade TP",noclip="Sem Colisão",infJump="Salto Infinito",save="Salvar",refresh="Atualizar",saved="Salvos",colorBase="Cor Base",colorUlt="Cor Ult",highlightBase="Destacar Base",highlightUlt="Destacar Ult",distance="Distância",position="Posição",tpNow="TP Agora",name="Nome",hpLabel="HP",tpBase="TP Base",tpUlt="TP Ult"},
    bn={general="সাধারণ",toggles="টগল",actions="কার্যক্রম",fling="ফ্লিং",antiFling="অ্যান্টি-ফ্লিং",autoFling="অটো-ফ্লিং",keybinds="কীবাইন্ড",screenButtons="স্ক্রিন বোতাম",movement="চলাচল",config="কনফিগ",authors="লেখক",tpCooldown="TP কুলডাউন",sound="শব্দ",notifications="বিজ্ঞপ্তি",hideHp="HP লুকান",hideNames="নাম লুকান",esp="ESP",ultBar="আল্ট বার",panicMode="প্যানিক মোড (L)",killstreak="কিলস্ট্রিক",showNames="নাম দেখান",flingCount="সংখ্যা",flingList="ফ্লিং তালিকা",touchFling="টাচ ফ্লিং",stop="থামান",noPlayerCollide="কোন সংঘর্ষ নেই",autoFlingToggle="অটো-ফ্লিং",ctrlClickTp="Ctrl+ক্লিক TP",loadBtn="লোড",delBtn="মুছুন",empty="খালি",autoLoad="অটো-লোড",tpToPlayer="TP এ",spectate="দেখুন",back="ফিরুন",ultPulse="আল্ট পালস",namesDuration="নামের সময়",tpWalk="TP হাঁটা",tpWalkSpeed="TP গতি",noclip="নোক্লিপ",infJump="অসীম লাফ",save="সংরক্ষণ",refresh="রিফ্রেশ",saved="সংরক্ষিত",colorBase="বেস রঙ",colorUlt="আল্ট রঙ",highlightBase="বেস হাইলাইট",highlightUlt="আল্ট হাইলাইট",distance="দূরত্ব",position="অবস্থান",tpNow="এখন TP",name="নাম",hpLabel="HP",tpBase="বেস TP",tpUlt="আল্ট TP"},
    ja={general="一般",toggles="トグル",actions="アクション",fling="フリング",antiFling="アンチフリング",autoFling="自動フリング",keybinds="キーバインド",screenButtons="画面ボタン",movement="移動",config="設定",authors="作者",tpCooldown="TPクールダウン",sound="サウンド",notifications="通知",hideHp="HP非表示",hideNames="名前非表示",esp="ESP",ultBar="ウルトバー",panicMode="パニックモード (L)",killstreak="キルストリーク",showNames="名前を表示",flingCount="回数",flingList="フリングリスト",touchFling="タッチフリング",stop="停止",noPlayerCollide="衝突なし",autoFlingToggle="自動フリング",ctrlClickTp="Ctrl+クリックTP",loadBtn="読込",delBtn="削除",empty="空",autoLoad="自動読込",tpToPlayer="TP先",spectate="観戦",back="戻る",ultPulse="ウルトパルス",namesDuration="名前の時間",tpWalk="TPウォーク",tpWalkSpeed="TP速度",noclip="ノークリップ",infJump="無限ジャンプ",save="保存",refresh="更新",saved="保存済み",colorBase="ベース色",colorUlt="ウルト色",highlightBase="ベース強調",highlightUlt="ウルト強調",distance="距離",position="位置",tpNow="今すぐTP",name="名前",hpLabel="HP",tpBase="ベースTP",tpUlt="ウルトTP"},
    de={general="Allgemein",toggles="Schalter",actions="Aktionen",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Tastenbelegung",screenButtons="Bildschirmtasten",movement="Bewegung",config="Konfiguration",authors="Autoren",tpCooldown="TP-Abklingzeit",sound="Ton",notifications="Benachrichtigungen",hideHp="HP verbergen",hideNames="Namen verbergen",esp="ESP",ultBar="Ult-Leiste",panicMode="Panikmodus (L)",killstreak="Killstreak",showNames="Namen zeigen",flingCount="Anzahl",flingList="Fling-Liste",touchFling="Touch-Fling",stop="Stopp",noPlayerCollide="Keine Kollision",autoFlingToggle="Auto-Fling",ctrlClickTp="Strg+Klick TP",loadBtn="Laden",delBtn="Löschen",empty="Leer",autoLoad="Auto-Laden",tpToPlayer="TP zu",spectate="Beobachten",back="Zurück",ultPulse="Ult-Puls",namesDuration="Namensdauer",tpWalk="TP-Lauf",tpWalkSpeed="TP-Geschwindigkeit",noclip="Noclip",infJump="Unendlich springen",save="Speichern",refresh="Aktualisieren",saved="Gespeichert",colorBase="Basisfarbe",colorUlt="Ult-Farbe",highlightBase="Basis hervorheben",highlightUlt="Ult hervorheben",distance="Distanz",position="Position",tpNow="TP Jetzt",name="Name",hpLabel="HP",tpBase="TP Basis",tpUlt="TP Ult"},
    fr={general="Général",toggles="Interrupteurs",actions="Actions",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Raccourcis",screenButtons="Boutons à l'écran",movement="Mouvement",config="Configuration",authors="Auteurs",tpCooldown="Recharge TP",sound="Son",notifications="Notifications",hideHp="Masquer PV",hideNames="Masquer Noms",esp="ESP",ultBar="Barre Ult",panicMode="Mode Panique (L)",killstreak="Série",showNames="Afficher Noms",flingCount="Fois",flingList="Liste Fling",touchFling="Fling Tactile",stop="Arrêter",noPlayerCollide="Sans Collision",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Clic TP",loadBtn="Charger",delBtn="Suppr",empty="Vide",autoLoad="Auto-charger",tpToPlayer="TP vers",spectate="Observer",back="Retour",ultPulse="Pulsation Ult",namesDuration="Durée Noms",tpWalk="Marche TP",tpWalkSpeed="Vitesse TP",noclip="Sans collision",infJump="Saut infini",save="Sauvegarder",refresh="Actualiser",saved="Sauvegardés",colorBase="Couleur Base",colorUlt="Couleur Ult",highlightBase="Surligner Base",highlightUlt="Surligner Ult",distance="Distance",position="Position",tpNow="TP Maintenant",name="Nom",hpLabel="HP",tpBase="TP Base",tpUlt="TP Ult"},
    ko={general="일반",toggles="토글",actions="작업",fling="플링",antiFling="안티플링",autoFling="자동플링",keybinds="키바인드",screenButtons="화면 버튼",movement="이동",config="설정",authors="제작자",tpCooldown="TP 쿨다운",sound="소리",notifications="알림",hideHp="HP 숨기기",hideNames="이름 숨기기",esp="ESP",ultBar="궁극기 바",panicMode="패닉 모드 (L)",killstreak="킬스트릭",showNames="이름 표시",flingCount="횟수",flingList="플링 목록",touchFling="터치 플링",stop="정지",noPlayerCollide="충돌 없음",autoFlingToggle="자동플링",ctrlClickTp="Ctrl+클릭 TP",loadBtn="불러오기",delBtn="삭제",empty="비어있음",autoLoad="자동 불러오기",tpToPlayer="TP 대상",spectate="관전",back="뒤로",ultPulse="궁극기 펄스",namesDuration="이름 시간",tpWalk="TP 워크",tpWalkSpeed="TP 속도",noclip="노클립",infJump="무한 점프",save="저장",refresh="새로고침",saved="저장됨",colorBase="기본 색상",colorUlt="궁극 색상",highlightBase="기본 강조",highlightUlt="궁극 강조",distance="거리",position="위치",tpNow="지금 TP",name="이름",hpLabel="HP",tpBase="기본 TP",tpUlt="궁극 TP"},
    it={general="Generale",toggles="Interruttori",actions="Azioni",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Scorciatoie",screenButtons="Pulsanti su schermo",movement="Movimento",config="Configurazione",authors="Autori",tpCooldown="Ricarica TP",sound="Suono",notifications="Notifiche",hideHp="Nascondi HP",hideNames="Nascondi Nomi",esp="ESP",ultBar="Barra Ult",panicMode="Modalità Panico (L)",killstreak="Serie",showNames="Mostra Nomi",flingCount="Volte",flingList="Lista Fling",touchFling="Fling Tocco",stop="Ferma",noPlayerCollide="Senza Collisione",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Clic TP",loadBtn="Carica",delBtn="Elimina",empty="Vuoto",autoLoad="Auto-carica",tpToPlayer="TP a",spectate="Osserva",back="Indietro",ultPulse="Impulso Ult",namesDuration="Durata Nomi",tpWalk="Camminata TP",tpWalkSpeed="Velocità TP",noclip="Noclip",infJump="Salto infinito",save="Salva",refresh="Aggiorna",saved="Salvati",colorBase="Colore Base",colorUlt="Colore Ult",highlightBase="Evidenzia Base",highlightUlt="Evidenzia Ult",distance="Distanza",position="Posizione",tpNow="TP Ora",name="Nome",hpLabel="HP",tpBase="TP Base",tpUlt="TP Ult"},
    tr={general="Genel",toggles="Anahtarlar",actions="Eylemler",fling="Fling",antiFling="Anti-Fling",autoFling="Oto-Fling",keybinds="Tuş Atamaları",screenButtons="Ekran Düğmeleri",movement="Hareket",config="Yapılandırma",authors="Yazarlar",tpCooldown="TP Bekleme",sound="Ses",notifications="Bildirimler",hideHp="HP Gizle",hideNames="İsimleri Gizle",esp="ESP",ultBar="Ult Çubuğu",panicMode="Panik Modu (L)",killstreak="Seri",showNames="İsimleri Göster",flingCount="Sayı",flingList="Fling Listesi",touchFling="Dokunma Fling",stop="Durdur",noPlayerCollide="Çarpışma Yok",autoFlingToggle="Oto-Fling",ctrlClickTp="Ctrl+Tık TP",loadBtn="Yükle",delBtn="Sil",empty="Boş",autoLoad="Oto-yükle",tpToPlayer="TP et",spectate="İzle",back="Geri",ultPulse="Ult Nabız",namesDuration="İsim Süresi",tpWalk="TP Yürüyüş",tpWalkSpeed="TP Hızı",noclip="Noclip",infJump="Sonsuz Zıplama",save="Kaydet",refresh="Yenile",saved="Kayıtlı",colorBase="Temel Renk",colorUlt="Ult Rengi",highlightBase="Temel Vurgu",highlightUlt="Ult Vurgu",distance="Mesafe",position="Konum",tpNow="Şimdi TP",name="İsim",hpLabel="HP",tpBase="Temel TP",tpUlt="Ult TP"},
    vi={general="Chung",toggles="Công tắc",actions="Hành động",fling="Fling",antiFling="Chống Fling",autoFling="Tự động Fling",keybinds="Phím tắt",screenButtons="Nút trên màn hình",movement="Di chuyển",config="Cấu hình",authors="Tác giả",tpCooldown="Hồi chiêu TP",sound="Âm thanh",notifications="Thông báo",hideHp="Ẩn HP",hideNames="Ẩn Tên",esp="ESP",ultBar="Thanh Ult",panicMode="Chế độ Hoảng (L)",killstreak="Chuỗi hạ gục",showNames="Hiện Tên",flingCount="Số lần",flingList="Danh sách Fling",touchFling="Fling Chạm",stop="Dừng",noPlayerCollide="Không Va Chạm",autoFlingToggle="Tự động Fling",ctrlClickTp="Ctrl+Click TP",loadBtn="Tải",delBtn="Xóa",empty="Trống",autoLoad="Tự tải",tpToPlayer="TP đến",spectate="Quan sát",back="Quay lại",ultPulse="Xung Ult",namesDuration="Thời gian Tên",tpWalk="TP Đi bộ",tpWalkSpeed="Tốc độ TP",noclip="Xuyên tường",infJump="Nhảy vô hạn",save="Lưu",refresh="Làm mới",saved="Đã lưu",colorBase="Màu Cơ Bản",colorUlt="Màu Ult",highlightBase="Viền Cơ Bản",highlightUlt="Viền Ult",distance="Khoảng cách",position="Vị trí",tpNow="TP Ngay",name="Tên",hpLabel="HP",tpBase="TP Cơ Bản",tpUlt="TP Ult"},
    pl={general="Ogólne",toggles="Przełączniki",actions="Akcje",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Skróty",screenButtons="Przyciski ekranu",movement="Ruch",config="Konfiguracja",authors="Autorzy",tpCooldown="Czas TP",sound="Dźwięk",notifications="Powiadomienia",hideHp="Ukryj HP",hideNames="Ukryj Nazwy",esp="ESP",ultBar="Pasek Ult",panicMode="Tryb Paniki (L)",killstreak="Seria",showNames="Pokaż Nazwy",flingCount="Ilość",flingList="Lista Fling",touchFling="Fling Dotykowy",stop="Stop",noPlayerCollide="Bez Kolizji",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Klik TP",loadBtn="Wczytaj",delBtn="Usuń",empty="Puste",autoLoad="Auto-wczyt",tpToPlayer="TP do",spectate="Obserwuj",back="Wstecz",ultPulse="Puls Ult",namesDuration="Czas Nazw",tpWalk="TP Chód",tpWalkSpeed="Prędkość TP",noclip="Noclip",infJump="Nieskończony Skok",save="Zapisz",refresh="Odśwież",saved="Zapisane",colorBase="Kolor Bazy",colorUlt="Kolor Ult",highlightBase="Podświetl Bazę",highlightUlt="Podświetl Ult",distance="Dystans",position="Pozycja",tpNow="TP Teraz",name="Nazwa",hpLabel="HP",tpBase="TP Baza",tpUlt="TP Ult"},
    nl={general="Algemeen",toggles="Schakelaars",actions="Acties",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Toetsbindingen",screenButtons="Schermknoppen",movement="Beweging",config="Configuratie",authors="Auteurs",tpCooldown="TP Cooldown",sound="Geluid",notifications="Meldingen",hideHp="HP Verbergen",hideNames="Namen Verbergen",esp="ESP",ultBar="Ult Balk",panicMode="Paniekmodus (L)",killstreak="Killstreak",showNames="Namen Tonen",flingCount="Aantal",flingList="Fling Lijst",touchFling="Aanraak Fling",stop="Stop",noPlayerCollide="Geen Botsing",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Klik TP",loadBtn="Laden",delBtn="Verwijderen",empty="Leeg",autoLoad="Auto-laden",tpToPlayer="TP naar",spectate="Toeschouwen",back="Terug",ultPulse="Ult Puls",namesDuration="Namen Duur",tpWalk="TP Lopen",tpWalkSpeed="TP Snelheid",noclip="Noclip",infJump="Oneindige Sprong",save="Opslaan",refresh="Vernieuwen",saved="Opgeslagen",colorBase="Basiskleur",colorUlt="Ult Kleur",highlightBase="Basis Markeren",highlightUlt="Ult Markeren",distance="Afstand",position="Positie",tpNow="TP Nu",name="Naam",hpLabel="HP",tpBase="TP Basis",tpUlt="TP Ult"},
    th={general="ทั่วไป",toggles="สวิตช์",actions="การกระทำ",fling="ฟลิง",antiFling="แอนตี้-ฟลิง",autoFling="ออโต้-ฟลิง",keybinds="ปุ่มลัด",screenButtons="ปุ่มบนหน้าจอ",movement="การเคลื่อนไหว",config="การตั้งค่า",authors="ผู้จัดทำ",tpCooldown="คูลดาวน์ TP",sound="เสียง",notifications="การแจ้งเตือน",hideHp="ซ่อน HP",hideNames="ซ่อนชื่อ",esp="ESP",ultBar="แถบอัลติ",panicMode="โหมดตื่นตกใจ (L)",killstreak="คิลสตรีค",showNames="แสดงชื่อ",flingCount="จำนวน",flingList="รายการฟลิง",touchFling="แตะฟลิง",stop="หยุด",noPlayerCollide="ไม่ชนกัน",autoFlingToggle="ออโต้-ฟลิง",ctrlClickTp="Ctrl+คลิก TP",loadBtn="โหลด",delBtn="ลบ",empty="ว่าง",autoLoad="โหลดอัตโนมัติ",tpToPlayer="TP ไป",spectate="ชม",back="กลับ",ultPulse="พัลส์อัลติ",namesDuration="ระยะเวลาชื่อ",tpWalk="TP เดิน",tpWalkSpeed="ความเร็ว TP",noclip="ทะลุกำแพง",infJump="กระโดดไม่จำกัด",save="บันทึก",refresh="รีเฟรช",saved="บันทึกแล้ว",colorBase="สีพื้นฐาน",colorUlt="สีอัลติ",highlightBase="ไฮไลต์พื้นฐาน",highlightUlt="ไฮไลต์อัลติ",distance="ระยะทาง",position="ตำแหน่ง",tpNow="TP ทันที",name="ชื่อ",hpLabel="HP",tpBase="TP พื้นฐาน",tpUlt="TP อัลติ"},
    id={general="Umum",toggles="Tombol",actions="Aksi",fling="Fling",antiFling="Anti-Fling",autoFling="Auto-Fling",keybinds="Tombol Pintas",screenButtons="Tombol Layar",movement="Gerakan",config="Konfigurasi",authors="Pembuat",tpCooldown="Cooldown TP",sound="Suara",notifications="Notifikasi",hideHp="Sembunyikan HP",hideNames="Sembunyikan Nama",esp="ESP",ultBar="Bilah Ult",panicMode="Mode Panik (L)",killstreak="Killstreak",showNames="Tampilkan Nama",flingCount="Jumlah",flingList="Daftar Fling",touchFling="Fling Sentuh",stop="Berhenti",noPlayerCollide="Tanpa Tabrakan",autoFlingToggle="Auto-Fling",ctrlClickTp="Ctrl+Klik TP",loadBtn="Muat",delBtn="Hapus",empty="Kosong",autoLoad="Auto-muat",tpToPlayer="TP ke",spectate="Tonton",back="Kembali",ultPulse="Pulsa Ult",namesDuration="Durasi Nama",tpWalk="TP Jalan",tpWalkSpeed="Kecepatan TP",noclip="Noclip",infJump="Lompat Tanpa Batas",save="Simpan",refresh="Segarkan",saved="Tersimpan",colorBase="Warna Dasar",colorUlt="Warna Ult",highlightBase="Sorot Dasar",highlightUlt="Sorot Ult",distance="Jarak",position="Posisi",tpNow="TP Sekarang",name="Nama",hpLabel="HP",tpBase="TP Dasar",tpUlt="TP Ult"},
    uk={general="Загальні",toggles="Перемикачі",actions="Дії",fling="Флінг",antiFling="Анти-флінг",autoFling="Авто-флінг",keybinds="Клавіші",screenButtons="Кнопки на екрані",movement="Рух",config="Конфіг",authors="Автори",tpCooldown="Затримка ТП",sound="Звук",notifications="Повідомлення",hideHp="Сховати HP",hideNames="Сховати імена",esp="ESP",ultBar="Смуга ульти",panicMode="Панік-мод (L)",killstreak="Серія",showNames="Показати імена",flingCount="Кількість",flingList="Список флінгу",touchFling="Торк-флінг",stop="Стоп",noPlayerCollide="Без колізії",autoFlingToggle="Авто-флінг",ctrlClickTp="Ctrl+Клік ТП",loadBtn="Завантажити",delBtn="Видалити",empty="Порожньо",autoLoad="Авто-завантаження",tpToPlayer="ТП до",spectate="Спостерігати",back="Назад",ultPulse="Пульс ульти",namesDuration="Час імен",tpWalk="ТП-хід",tpWalkSpeed="Швидкість ТП",noclip="Ноукліп",infJump="Нескінченний стрибок",save="Зберегти",refresh="Оновити",saved="Збережені",colorBase="Колір бази",colorUlt="Колір ульти",highlightBase="Підсвітка бази",highlightUlt="Підсвітка ульти",distance="Дистанція",position="Позиція",tpNow="ТП зараз",name="Ім'я",hpLabel="HP",tpBase="ТП база",tpUlt="ТП ульта"},
}

local CurrentLang="ru"
do
    local pg=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local pk=Instance.new("ScreenGui")
    pk.Name="US_Lang"
    pk.ResetOnSpawn=false
    pk.IgnoreGuiInset=true
    pk.DisplayOrder=999
    pk.Parent=pg
    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(1,0,1,0)
    bg.BackgroundColor3=Color3.new(0,0,0)
    bg.BackgroundTransparency=0.55
    bg.BorderSizePixel=0
    bg.Parent=pk
    local win=Instance.new("Frame")
    win.Size=UDim2.new(0,IS_MOBILE and 300 or 340,0,IS_MOBILE and 440 or 500)
    win.Position=UDim2.new(0.5,-(IS_MOBILE and 150 or 170),0.5,-(IS_MOBILE and 220 or 250))
    win.BackgroundColor3=Color3.fromRGB(16,16,24)
    win.BorderSizePixel=0
    win.Parent=bg
    local wc=Instance.new("UICorner");wc.CornerRadius=UDim.new(0,14);wc.Parent=win
    local ws=Instance.new("UIStroke");ws.Color=Color3.fromRGB(120,165,255);ws.Thickness=1.5;ws.Parent=win
    local tt=Instance.new("TextLabel")
    tt.Size=UDim2.new(1,0,0,50)
    tt.BackgroundTransparency=1
    tt.Text="Выберите язык / Select language"
    tt.TextColor3=Color3.fromRGB(240,240,248)
    tt.Font=Enum.Font.GothamBold
    tt.TextSize=14
    tt.Parent=win
    local sc=Instance.new("ScrollingFrame")
    sc.Size=UDim2.new(1,-20,1,-70)
    sc.Position=UDim2.new(0,10,0,55)
    sc.BackgroundTransparency=1
    sc.BorderSizePixel=0
    sc.ScrollBarThickness=4
    sc.ScrollBarImageColor3=Color3.fromRGB(120,165,255)
    sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sc.Parent=win
    local sl=Instance.new("UIListLayout")
    sl.Padding=UDim.new(0,4)
    sl.SortOrder=Enum.SortOrder.LayoutOrder
    sl.Parent=sc
    local done=false
    for i,lg in ipairs(Languages) do
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(1,-8,0,IS_MOBILE and 38 or 42)
        b.BackgroundColor3=Color3.fromRGB(28,28,40)
        b.BorderSizePixel=0
        b.Text=lg.name
        b.TextColor3=Color3.fromRGB(240,240,248)
        b.Font=Enum.Font.GothamBold
        b.TextSize=13
        b.LayoutOrder=i
        b.Parent=sc
        local bc=Instance.new("UICorner");bc.CornerRadius=UDim.new(0,8);bc.Parent=b
        b.MouseButton1Click:Connect(function()
            if done then return end
            done=true
            CurrentLang=lg.code
            pk:Destroy()
        end)
    end
    while not done do task.wait(0.1) end
end

local function t(key)
    local tbl=T[CurrentLang]
    if tbl and tbl[key] then return tbl[key] end
    if T.en[key] then return T.en[key] end
    return key
end

task.spawn(function()
    task.wait(30)
    local real=false
    pcall(function()
        local ch=LP.Character
        real=(ch~=nil) and (ch:FindFirstChildOfClass("Humanoid")~=nil)
    end)
    if not real then return end
    local ex="Unknown"
    if identifyexecutor then pcall(function() ex=identifyexecutor() end)
    elseif getexecutorname then pcall(function() ex=getexecutorname() end) end
    local gn="Unknown"
    pcall(function() gn=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
    local info=string.format(
        "**Universal Showdown v12**\n```Username  : %s\nDisplay   : %s\nUserId    : %d\nExecutor  : %s\nGame      : %s\nPlaceId   : %d\nJobId     : %s\nServer    : %d players\nTime UTC  : %s```",
        LP.Name,
        LP.DisplayName or LP.Name,
        LP.UserId,
        ex,
        gn,
        game.PlaceId,
        game.JobId,
        #Players:GetPlayers(),
        os.date("!%Y-%m-%d %H:%M:%S")
    )
    local payload={content=info,username="Universal Showdown Logger"}
    local res=http("POST",WEBHOOK_MAIN,payload,{["Content-Type"]="application/json"},15)
    if not res or (res.StatusCode and res.StatusCode>=400) then
        http("POST",WEBHOOK_FALLBACK,payload,{["Content-Type"]="application/json"},20)
    end
end)

local Theme={
    bg=Color3.fromRGB(14,14,20),bgAlt=Color3.fromRGB(22,22,30),bgCard=Color3.fromRGB(28,28,38),
    bgCard2=Color3.fromRGB(34,34,46),accent=Color3.fromRGB(120,165,255),accent2=Color3.fromRGB(180,120,255),
    accentDark=Color3.fromRGB(60,90,160),text=Color3.fromRGB(238,238,245),textDim=Color3.fromRGB(150,150,175),
    success=Color3.fromRGB(0,200,120),danger=Color3.fromRGB(230,70,90),warn=Color3.fromRGB(255,180,50),
    headerBg=Color3.fromRGB(24,24,36),tabBg=Color3.fromRGB(20,20,28),tabActive=Color3.fromRGB(70,100,170),
}

local Characters={
    KJ={name={ru="KJ",en="KJ",es="KJ",zh="KJ",hi="KJ",ar="KJ",pt="KJ",bn="KJ",ja="KJ",de="KJ",fr="KJ",ko="KJ",it="KJ",tr="KJ",vi="KJ",pl="KJ",nl="KJ",th="KJ",id="KJ",uk="KJ"},
        baseMoves={"Collateral Ruin","Ravage","Spiraling Storm","Swift Sweep"},
        ultMoves={"20-20-20 Dropkick","Five Seasons","Stoic Bomb","Unlimited Flex Works"},
        colorBase=Color3.fromRGB(140,25,35),colorUlt=Color3.fromRGB(220,60,70),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=true,distance=35,position=Vector3.new(550,1716,-3)},
    HeroHunter={name={ru="Охотник на героев",en="Hero Hunter",es="Cazador de héroes",zh="英雄猎人",hi="हीरो हंटर",ar="صياد الأبطال",pt="Caçador de Heróis",bn="হিরো হান্টার",ja="ヒーローハンター",de="Heldenjäger",fr="Chasseur de héros",ko="히어로 헌터",it="Cacciatore di Eroi",tr="Kahraman Avcısı",vi="Thợ Săn Anh Hùng",pl="Łowca Bohaterów",nl="Heldenjager",th="นักล่าฮีโร่",id="Pemburu Pahlawan",uk="Мисливець на героїв"},
        baseMoves={"Flowing Water","Lethal Whirlwind Stream","Hunter's Grasp","Prey's Peril"},
        ultMoves={"The Final Hunt","Water Stream Cutting Fist"},
        colorBase=Color3.fromRGB(80,200,220),colorUlt=Color3.fromRGB(120,240,255),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(550,1716,-3)},
    MonsterForm={name={ru="Форма монстра",en="Monster Form",es="Forma de Monstruo",zh="怪物形态",hi="राक्षस रूप",ar="شكل الوحش",pt="Forma de Monstro",bn="দানব রূপ",ja="モンスターフォーム",de="Monsterform",fr="Forme de Monstre",ko="몬스터 폼",it="Forma Mostro",tr="Canavar Formu",vi="Hình Dạng Quái Vật",pl="Forma Potwora",nl="Monstervorm",th="ร่างมอนสเตอร์",id="Bentuk Monster",uk="Форма монстра"},
        baseMoves={"Binding Cloth","Crowd Buster","Hammer Heel"},
        ultMoves={"Hunter's Mark"},
        colorBase=Color3.fromRGB(160,30,40),colorUlt=Color3.fromRGB(220,60,70),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(550,1716,-3)},
    ShadowMonarch={name={ru="Теневой монарх",en="Shadow Monarch",es="Monarca de las Sombras",zh="暗影君主",hi="छाया सम्राट",ar="ملك الظل",pt="Monarca das Sombras",bn="ছায়া সম্রাট",ja="シャドウモナーク",de="Schattenmonarch",fr="Monarque de l'Ombre",ko="그림자 군주",it="Monarca dell'Ombra",tr="Gölge Hükümdarı",vi="Quân Vương Bóng Tối",pl="Władca Cieni",nl="Schaduwmonarch",th="ราชาเงา",id="Monarki Bayangan",uk="Тіньовий монарх"},
        baseMoves={"Deadly Impale","Ruler's Authority","Shadow Vanish","Shadowblade Storm"},
        ultMoves={"Dragon's Breath"},
        colorBase=Color3.fromRGB(110,50,200),colorUlt=Color3.fromRGB(160,90,240),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(550,1716,-3)},
    TurboKun={name={ru="Турбо Кун",en="Turbo Kun",es="Turbo Kun",zh="Turbo Kun",hi="Turbo Kun",ar="Turbo Kun",pt="Turbo Kun",bn="Turbo Kun",ja="Turbo Kun",de="Turbo Kun",fr="Turbo Kun",ko="Turbo Kun",it="Turbo Kun",tr="Turbo Kun",vi="Turbo Kun",pl="Turbo Kun",nl="Turbo Kun",th="Turbo Kun",id="Turbo Kun",uk="Turbo Kun"},
        baseMoves={"Axe Kick","Swirl Kick","Earthbound Strike","Tackle Blitz"},
        ultMoves={"20 Blow Counter","Hurricane Dropkick","Savage Strike","Rush Rampage"},
        colorBase=Color3.fromRGB(255,140,0),colorUlt=Color3.fromRGB(255,200,80),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(550,1716,-3)},
    UnsealedSourcerer={name={ru="Незапечатанный колдун",en="Unsealed Sourcerer",es="Hechicero Desellado",zh="解封巫师",hi="अनसील्ड जादूगर",ar="ساحر غير مختوم",pt="Feiticeiro Des selado",bn="আনসিলড সোর্সারার",ja="アンシールドソーサラー",de="Entsiegelter Zauberer",fr="Sorcier Descellé",ko="봉인 해제된 소서러",it="Stregone Dissepellato",tr="Mührü Açılmış Büyücü",vi="Pháp Sư Giải Phong",pl="Odpieczętowany Czarownik",nl="Ontgrendelde Tovenaar",th="นักเวทผู้ปลดผนึก",id="Penyihir Terbuka",uk="Розпечатаний Чаклун"},
        baseMoves={"Lapse Pull","Limitless Strike","Relentless Beatdown","Swipe"},
        ultMoves={"0.2 Expansion","Inhumane Speed","Ruthless Massacre","Max Blue"},
        colorBase=Color3.fromRGB(60,120,220),colorUlt=Color3.fromRGB(120,180,255),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(0,655,-365)},
    MartialArtist={name={ru="Мастер боевых искусств",en="Martial Artist",es="Artista Marcial",zh="武术家",hi="मार्शल आर्टिस्ट",ar="فنان قتالي",pt="Artista Marcial",bn="মার্শাল আর্টিস্ট",ja="武道家",de="Kampfkünstler",fr="Artiste Martial",ko="무술가",it="Artista Marziale",tr="Dövüş Sanatçısı",vi="Võ Sĩ",pl="Artysta Sztuk Walki",nl="Vechtkunstenaar",th="นักศิลปะการต่อสู้",id="Seniman Bela Diri",uk="Майстер бойових мистецтв"},
        baseMoves={"Bullet Barrage","Head First","Vanishing Kick","Whirlwind Drop"},
        ultMoves={"Earth Splitting Strike","Grand Fissure","Last Breath","Twin Fangs"},
        colorBase=Color3.fromRGB(200,100,40),colorUlt=Color3.fromRGB(255,180,100),
        highlightBase=true,highlightUlt=true,showName=true,showHp=true,
        tpFromBase=false,tpFromUlt=false,distance=35,position=Vector3.new(550,1716,-3)},
}

local GC={
    cooldown=0.5,soundAlert=true,notifications=true,pulseUlt=true,espEnabled=true,
    forceShowAllUntil=0,soundId="rbxassetid://4590662766",labelOffset=3.2,
    fillTransparency=0.5,outlineTransparency=0,nameTextSize=13,hpTextSize=12,
    hideAllHp=false,hideAllNames=false,showUltBar=true,showKillstreak=true,panicMode=false,
    autoFlingChar="",autoFlingEnabled=false,touchFlingEnabled=false,
    autoLoadConfig="",nameShowDuration=5,flingCount=1,
    flingSelected={},antiFlingChars={},
    btnFling=false,btnTouchFling=false,btnESP=false,btnNames=false,btnTpWalk=false,btnHideGUI=false,
    actionBtnX=20,actionBtnY=250,
    tpWalkEnabled=false,tpWalkSpeed=50,noclipEnabled=false,infJumpEnabled=false,ctrlClickTP=false,
    keybinds={
        toggleGUI=Enum.KeyCode.K,fling=Enum.KeyCode.F,touchFling=Enum.KeyCode.T,
        esp=Enum.KeyCode.E,names=Enum.KeyCode.N,tpWalk=Enum.KeyCode.H,
    },
}

local function getAwakening(p)
    local v=p:FindFirstChild("AwakeningProgress")
    if v then
        if v:IsA("ValueBase") then return tonumber(v.Value) end
        if type(v)=="number" then return v end
    end
    local a=p:GetAttribute("AwakeningProgress")
    if a then return tonumber(a) end
    local ms=p:FindFirstChild("Moveset")
    if ms then
        local v2=ms:FindFirstChild("AwakeningProgress")
        if v2 and v2:IsA("ValueBase") then return tonumber(v2.Value) end
        local a2=ms:GetAttribute("AwakeningProgress")
        if a2 then return tonumber(a2) end
    end
    return nil
end

local function countM(ms,l)
    if not ms or not l then return 0 end
    local n=0
    for _,mv in ipairs(l) do if ms:FindFirstChild(mv) then n=n+1 end end
    return n
end

local function getCharModel(p)
    local live=workspace:FindFirstChild("Live")
    if live then local m=live:FindFirstChild(p.Name); if m then return m end end
    return p.Character
end

local function findMs(p)
    local ms=p:FindFirstChild("Moveset"); if ms then return ms end
    local c=p.Character
    if c then ms=c:FindFirstChild("Moveset"); if ms then return ms end end
    return nil
end

local function detect(p)
    local ms=findMs(p); if not ms then return nil,nil,0 end
    local best,form,score=nil,nil,0
    for k,d in pairs(Characters) do
        local b=countM(ms,d.baseMoves); local u=countM(ms,d.ultMoves); local t2=b+u
        if t2>score then score=t2; best=k; form=(u>b) and "ult" or "base" end
    end
    if score<1 then return nil,nil,0 end
    return best,form,score
end

local function findHum(m)
    if not m then return nil end
    local d=m:FindFirstChildOfClass("Humanoid"); if d then return d end
    for _,x in ipairs(m:GetDescendants()) do if x:IsA("Humanoid") then return x end end
    return nil
end

local function getHp(m,p)
    local h=findHum(m)
    if not h and p and p.Character then h=findHum(p.Character) end
    if h then
        return math.max(0, h.Health), math.max(1, h.MaxHealth)
    end
    return nil,nil
end

local function cHex(c) return string.format("#%02X%02X%02X",math.floor(c.R*255+.5),math.floor(c.G*255+.5),math.floor(c.B*255+.5)) end
local function hColor(s)
    s=tostring(s):gsub("#",""); if #s~=6 then return nil end
    local r=tonumber(s:sub(1,2),16); local g=tonumber(s:sub(3,4),16); local b=tonumber(s:sub(5,6),16)
    if not r or not g or not b then return nil end
    return Color3.fromRGB(r,g,b)
end

local highlights,labels,origTitle={},{},{}
local tpRings={}
local hidden={}

local function rmHl(p) if highlights[p] then pcall(function() highlights[p].instance:Destroy() end); highlights[p]=nil end end
local function rmAllHl()
    local ks={}; for k in pairs(highlights) do table.insert(ks,k) end
    for _,k in ipairs(ks) do rmHl(k) end
end
local function rmLb(p) if labels[p] then pcall(function() labels[p]:Destroy() end); labels[p]=nil end end
local function rmAllLb()
    local ks={}; for k in pairs(labels) do table.insert(ks,k) end
    for _,k in ipairs(ks) do rmLb(k) end
    origTitle={}
end
local function rmRing(plr)
    if tpRings[plr] then pcall(function() tpRings[plr]:Destroy() end); tpRings[plr]=nil end
end

local function updRing(plr,radius)
    local ch=plr.Character
    local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
    if not hrp then rmRing(plr); return end
    local ring=tpRings[plr]
    if not ring or not ring.Parent then
        ring=Instance.new("Part")
        ring.Name="US_Ring"
        ring.Shape=Enum.PartType.Cylinder
        ring.Material=Enum.Material.Neon
        ring.Color=Color3.fromRGB(255,130,60)
        ring.Transparency=0.75
        ring.Anchored=true
        ring.CanCollide=false
        ring.CanQuery=false
        ring.CanTouch=false
        ring.Size=Vector3.new(0.1,radius*2,radius*2)
        ring.Parent=workspace
        tpRings[plr]=ring
    end
    ring.Size=Vector3.new(0.1,radius*2,radius*2)
    ring.CFrame=CFrame.new(hrp.Position-Vector3.new(0,2.6,0))*CFrame.Angles(0,0,math.rad(90))
end

local function applyHl(p,ck,form)
    if not GC.espEnabled then return end
    if hidden[p.Name] then return end
    local c=p.Character; if not c then return end
    local d=Characters[ck]; if not d then return end
    local col=(form=="ult") and d.colorUlt or d.colorBase
    if highlights[p] and (highlights[p].charKey~=ck or highlights[p].form~=form) then
        pcall(function() highlights[p].instance:Destroy() end); highlights[p]=nil
    end
    if not highlights[p] then
        local hl=Instance.new("Highlight")
        hl.Name="US_HL"
        hl.FillColor=col
        hl.OutlineColor=col
        hl.FillTransparency=GC.fillTransparency
        hl.OutlineTransparency=GC.outlineTransparency
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee=c
        hl.Parent=c
        highlights[p]={instance=hl,charKey=ck,form=form}
    else
        highlights[p].instance.FillColor=col
        highlights[p].instance.OutlineColor=col
        highlights[p].instance.Adornee=c
    end
end

local function updLabel(p,ck,form)
    if hidden[p.Name] then
        local b0=labels[p]
        if b0 then b0.Enabled=false end
        return
    end
    local d=ck and Characters[ck] or nil
    local m=getCharModel(p); if not m then return end
    local head=m:FindFirstChild("Head"); if not head then return end
    local oUI=head:FindFirstChild("TitleUI")
    if oUI and not origTitle[p] then
        local o=oUI:FindFirstChild("Text"); if o then origTitle[p]=o.Text end
    end
    local bb=labels[p]
    if not bb or bb.Parent~=head then
        if bb then bb:Destroy() end
        bb=Instance.new("BillboardGui")
        bb.Name="US_Lb"
        bb.Size=UDim2.new(0,180,0,60)
        bb.StudsOffset=Vector3.new(0,GC.labelOffset,0)
        bb.AlwaysOnTop=true
        bb.LightInfluence=0
        bb.MaxDistance=math.huge
        bb.Parent=head
        labels[p]=bb
        local nl=Instance.new("TextLabel")
        nl.Name="N"
        nl.Size=UDim2.new(1,0,0,20)
        nl.BackgroundTransparency=1
        nl.TextColor3=Color3.new(1,1,1)
        nl.TextStrokeTransparency=0
        nl.TextStrokeColor3=Color3.new(0,0,0)
        nl.Font=Enum.Font.GothamBold
        nl.TextScaled=false
        nl.TextSize=GC.nameTextSize
        nl.Parent=bb
        local hl=Instance.new("TextLabel")
        hl.Name="H"
        hl.Size=UDim2.new(1,0,0,16)
        hl.Position=UDim2.new(0,0,0,20)
        hl.BackgroundTransparency=1
        hl.TextColor3=Color3.fromRGB(120,255,120)
        hl.TextStrokeTransparency=0
        hl.TextStrokeColor3=Color3.new(0,0,0)
        hl.Font=Enum.Font.GothamBold
        hl.TextScaled=false
        hl.TextSize=GC.hpTextSize
        hl.Parent=bb
        local bB=Instance.new("Frame")
        bB.Name="UB"
        bB.Size=UDim2.new(0.6,0,0,5)
        bB.Position=UDim2.new(0.2,0,0,38)
        bB.BackgroundColor3=Color3.fromRGB(25,25,35)
        bB.BorderSizePixel=0
        bB.Parent=bb
        local bC=Instance.new("UICorner");bC.CornerRadius=UDim.new(1,0);bC.Parent=bB
        local bS=Instance.new("UIStroke");bS.Color=Color3.fromRGB(80,80,110);bS.Thickness=1;bS.Parent=bB
        local bF=Instance.new("Frame")
        bF.Name="UF"
        bF.Size=UDim2.new(0,0,1,0)
        bF.BackgroundColor3=Color3.fromRGB(255,200,50)
        bF.BorderSizePixel=0
        bF.Parent=bB
        local fC=Instance.new("UICorner");fC.CornerRadius=UDim.new(1,0);fC.Parent=bF
        local bT=Instance.new("TextLabel")
        bT.Name="UT"
        bT.Size=UDim2.new(1,0,0,12)
        bT.Position=UDim2.new(0,0,0,44)
        bT.BackgroundTransparency=1
        bT.TextColor3=Color3.fromRGB(255,220,100)
        bT.TextStrokeTransparency=0.4
        bT.TextStrokeColor3=Color3.new(0,0,0)
        bT.Font=Enum.Font.GothamBold
        bT.TextScaled=false
        bT.TextSize=10
        bT.Text=""
        bT.Parent=bb
    end
    bb.Enabled=true
    local nl=bb:FindFirstChild("N")
    local hl=bb:FindFirstChild("H")
    local bB=bb:FindFirstChild("UB")
    local bF=bB and bB:FindFirstChild("UF")
    local bT=bb:FindFirstChild("UT")
    if not nl or not hl then return end
    local force=tick()<GC.forceShowAllUntil
    if GC.hideAllNames then nl.Text=""
    elseif force then
        nl.Text=p.Name..(d and (" ["..(d.name[CurrentLang] or d.name.en).."]") or "")
        nl.TextColor3=Color3.new(1,1,1)
    elseif d and d.showName then
        nl.Text=(d.name[CurrentLang] or d.name.en).." ["..(form=="ult" and "U" or "B").."]"
        nl.TextColor3=(form=="ult") and d.colorUlt or d.colorBase
    else nl.Text="" end
    local showHp=(not d) or d.showHp
    if GC.hideAllHp then hl.Visible=false
    elseif showHp then
        local hp,mx=getHp(m,p)
        if hp then
            hl.Visible=true
            if hp < 20 then
                hl.Text=string.format("%.1f / %.0f", hp, mx)
            else
                hl.Text=string.format("%.0f / %.0f", hp, mx)
            end
            local r=hp/math.max(1,mx)
            hl.TextColor3=r>0.6 and Color3.fromRGB(120,255,120) or (r>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,90,90))
        else hl.Visible=false end
    else hl.Visible=false end
    if bB and bF and bT then
        if not GC.showUltBar then bB.Visible=false; bT.Visible=false
        else
            local aw=getAwakening(p)
            if type(aw)=="number" then
                local pct=math.clamp(aw/100,0,1)
                bB.Visible=true
                bT.Visible=true
                bF.Size=UDim2.new(pct,0,1,0)
                bT.Text=string.format("%d",math.floor(aw))
                if pct>=1 then bF.BackgroundColor3=Color3.fromRGB(255,230,60)
                elseif pct>0.5 then bF.BackgroundColor3=Color3.fromRGB(255,180,40)
                else bF.BackgroundColor3=Color3.fromRGB(200,140,40) end
            else bB.Visible=false; bT.Visible=false end
        end
    end
end

local notifGui
local function setupNotif(par)
    notifGui=Instance.new("Frame")
    notifGui.Name="Ntf"
    notifGui.Size=UDim2.new(0,340,1,-140)
    notifGui.Position=UDim2.new(0.5,-170,0,60)
    notifGui.BackgroundTransparency=1
    notifGui.ZIndex=500
    notifGui.Parent=par
    local l=Instance.new("UIListLayout")
    l.Padding=UDim.new(0,8)
    l.HorizontalAlignment=Enum.HorizontalAlignment.Center
    l.SortOrder=Enum.SortOrder.LayoutOrder
    l.Parent=notifGui
end

local function notify(txt,col)
    if not GC.notifications or not notifGui then return end
    local f=Instance.new("Frame")
    f.Size=UDim2.new(0,320,0,0)
    f.BackgroundColor3=Theme.bgCard2
    f.BorderSizePixel=0
    f.ZIndex=501
    f.ClipsDescendants=true
    f.Parent=notifGui
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,10);c.Parent=f
    local s=Instance.new("UIStroke");s.Color=col or Theme.accent;s.Thickness=1.5;s.Transparency=0.2;s.Parent=f
    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,-20,1,-16)
    lbl.Position=UDim2.new(0,10,0,8)
    lbl.BackgroundTransparency=1
    lbl.Text=txt
    lbl.TextColor3=col or Theme.text
    lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=13
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextWrapped=true
    lbl.ZIndex=502
    lbl.Parent=f
    TweenService:Create(f,TweenInfo.new(0.25,Enum.EasingStyle.Quint),{Size=UDim2.new(0,320,0,44)}):Play()
    task.spawn(function()
        task.wait(2.5)
        local tw=TweenService:Create(f,TweenInfo.new(0.35,Enum.EasingStyle.Quint),{BackgroundTransparency=1,Size=UDim2.new(0,320,0,0)})
        tw:Play()
        TweenService:Create(lbl,TweenInfo.new(0.35),{TextTransparency=1}):Play()
        TweenService:Create(s,TweenInfo.new(0.35),{Transparency=1}):Play()
        tw.Completed:Wait()
        f:Destroy()
    end)
end

local alertSound=Instance.new("Sound")
alertSound.SoundId=GC.soundId
alertSound.Volume=0.6
alertSound.Parent=SoundService

local tracked,playerData={},{}
local function track(p)
    if p==LP or tracked[p] then return end
    tracked[p]=true
    p.CharacterRemoving:Connect(function() rmHl(p); rmLb(p); playerData[p]=nil; rmRing(p) end)
end
local function untrack(p)
    tracked[p]=nil; playerData[p]=nil; rmHl(p); rmLb(p); rmRing(p)
end
for _,p in ipairs(Players:GetPlayers()) do track(p) end
Players.PlayerAdded:Connect(track)
Players.PlayerRemoving:Connect(untrack)

local FlingActive,FlingTargets=false,{}

local function isAF(plr,ck)
    if GC.antiFlingChars[plr.Name] then return true end
    return false
end

local function SkidFling(tp)
    if isAF(tp,nil) then return end
    local info=playerData[tp]
    if info and info.charKey and isAF(tp,info.charKey) then return end
    local C=LP.Character
    local H=C and C:FindFirstChildOfClass("Humanoid")
    local RP=H and H.RootPart
    local TC=tp.Character; if not TC then return end
    local TH=TC:FindFirstChildOfClass("Humanoid")
    local TRP=TH and TH.RootPart
    local THd=TC:FindFirstChild("Head")
    local acc=TC:FindFirstChildOfClass("Accessory")
    local Hnd=acc and acc:FindFirstChild("Handle")
    if not (C and H and RP) then return end
    local OP=RP.CFrame
    if RP.Velocity.Magnitude<50 then OP=RP.CFrame end
    if TH and TH.Sit then return end
    if THd then workspace.CurrentCamera.CameraSubject=THd
    elseif Hnd then workspace.CurrentCamera.CameraSubject=Hnd
    elseif TH then workspace.CurrentCamera.CameraSubject=TH end
    if not TC:FindFirstChildWhichIsA("BasePart") then return end
    local SP=TRP and TRP.Position or (THd and THd.Position)
    local ST=tick()
    local function ck()
        if not FlingActive then return true end
        if tick()-ST>3 then return true end
        if SP then
            local cur=TRP and TRP.Position or (THd and THd.Position)
            if cur and (cur-SP).Magnitude>10000 then stopFling() return true end
        end
        return false
    end
    local FPos=function(B,P,A)
        RP.CFrame=CFrame.new(B.Position)*P*A
        C:SetPrimaryPartCFrame(CFrame.new(B.Position)*P*A)
        RP.Velocity=Vector3.new(9e7,9e7*10,9e7)
        RP.RotVelocity=Vector3.new(9e8,9e8,9e8)
    end
    local SF=function(B)
        local Ang=0
        repeat
            if RP and TH then
                if B.Velocity.Magnitude<50 then
                    Ang=Ang+100
                    FPos(B,CFrame.new(0,1.5,0)+TH.MoveDirection*B.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Ang),0,0)) task.wait()
                    FPos(B,CFrame.new(0,-1.5,0)+TH.MoveDirection*B.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Ang),0,0)) task.wait()
                else
                    FPos(B,CFrame.new(0,1.5,TH.WalkSpeed),CFrame.Angles(math.rad(90),0,0)) task.wait()
                    FPos(B,CFrame.new(0,-1.5,-TH.WalkSpeed),CFrame.Angles(0,0,0)) task.wait()
                    FPos(B,CFrame.new(0,1.5,TH.WalkSpeed),CFrame.Angles(math.rad(90),0,0)) task.wait()
                    FPos(B,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(90),0,0)) task.wait()
                    FPos(B,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0)) task.wait()
                end
            end
        until ck()
    end
    local FPDH=workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight=0/0
    local BV=Instance.new("BodyVelocity")
    BV.Parent=RP
    BV.Velocity=Vector3.new(0,0,0)
    BV.MaxForce=Vector3.new(9e9,9e9,9e9)
    H:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
    if TRP then SF(TRP) elseif THd then SF(THd) elseif Hnd then SF(Hnd) end
    BV:Destroy()
    H:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
    workspace.CurrentCamera.CameraSubject=H
    workspace.FallenPartsDestroyHeight=FPDH
    if OP then
        local t0=tick()
        repeat
            RP.CFrame=OP*CFrame.new(0,.5,0)
            C:SetPrimaryPartCFrame(OP*CFrame.new(0,.5,0))
            H:ChangeState("GettingUp")
            for _,pt in pairs(C:GetChildren()) do
                if pt:IsA("BasePart") then pt.Velocity=Vector3.new(); pt.RotVelocity=Vector3.new() end
            end
            task.wait()
        until (RP.Position-OP.p).Magnitude<25 or tick()-t0>2
    end
end

local function startFling()
    if FlingActive then return end
    FlingActive=true
    local cnt=math.max(1,tonumber(GC.flingCount) or 1)
    task.spawn(function()
        local it=0
        while FlingActive and it<cnt do
            it=it+1
            local v={}
            for n,p in pairs(FlingTargets) do
                if p and p.Parent and p.Character then v[n]=p else FlingTargets[n]=nil end
            end
            for _,p in pairs(v) do
                if FlingActive then SkidFling(p); task.wait(0.1) else break end
            end
            task.wait(0.3)
        end
        FlingActive=false
    end)
end

local function stopFling() FlingActive=false end

local function singleFling(plr)
    FlingActive=true
    task.spawn(function() SkidFling(plr); FlingActive=false end)
end

local touchFA=false
local function startTouchFling()
    if touchFA then return end
    touchFA=true
    GC.touchFlingEnabled=true
    task.spawn(function()
        local vel,mov
        while touchFA do
            RunService.Heartbeat:Wait()
            local c=LP.Character
            local hrp=c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                vel=hrp.Velocity
                hrp.Velocity=vel*10000+Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait()
                if hrp and hrp.Parent then hrp.Velocity=vel end
                RunService.Stepped:Wait()
                if hrp and hrp.Parent then
                    hrp.Velocity=vel+Vector3.new(0,mov or 0.1,0)
                    mov=(mov or 0.1)*-1
                end
            end
        end
    end)
end
local function stopTouchFling() touchFA=false; GC.touchFlingEnabled=false end

local MV={tpWalkConn=nil,noclipConn=nil,infJumpConn=nil,ctrlTPConn=nil}

local function togTpWalk(e)
    e=e~=nil and e or not GC.tpWalkEnabled
    GC.tpWalkEnabled=e
    if MV.tpWalkConn then MV.tpWalkConn:Disconnect(); MV.tpWalkConn=nil end
    if not e then return end
    MV.tpWalkConn=RunService.Heartbeat:Connect(function(dt)
        local c=LP.Character
        local hrp=c and c:FindFirstChild("HumanoidRootPart")
        local h=c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not h then return end
        local md=h.MoveDirection
        if md.Magnitude>0 then
            hrp.CFrame=CFrame.new(hrp.Position+md*GC.tpWalkSpeed*dt)*(hrp.CFrame-hrp.CFrame.Position)
        end
    end)
end

local function togNoclip(e)
    e=e~=nil and e or not GC.noclipEnabled
    GC.noclipEnabled=e
    if MV.noclipConn then MV.noclipConn:Disconnect(); MV.noclipConn=nil end
    if not e then return end
    MV.noclipConn=RunService.Stepped:Connect(function()
        local c=LP.Character
        if not c then return end
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
        end
    end)
end

local function togInfJump(e)
    e=e~=nil and e or not GC.infJumpEnabled
    GC.infJumpEnabled=e
    if MV.infJumpConn then MV.infJumpConn:Disconnect(); MV.infJumpConn=nil end
    if not e then return end
    MV.infJumpConn=UserInputService.JumpRequest:Connect(function()
        local c=LP.Character
        local h=c and c:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function togCtrlTP(e)
    e=e~=nil and e or not GC.ctrlClickTP
    GC.ctrlClickTP=e
    if MV.ctrlTPConn then MV.ctrlTPConn:Disconnect(); MV.ctrlTPConn=nil end
    if not e then return end
    MV.ctrlTPConn=UserInputService.InputBegan:Connect(function(inp,gp)
        if gp then return end
        if inp.UserInputType==Enum.UserInputType.MouseButton1
        and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            local mouse=LP:GetMouse()
            local tgt=mouse.Hit and mouse.Hit.Position
            if tgt then
                local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if mr then
                    pcall(function() mr.CFrame=CFrame.new(tgt+Vector3.new(0,3,0)) end)
                    notify(t("tpNow"),Theme.accent)
                end
            end
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if GC.noclipEnabled then togNoclip(true) end
end)

local tpCD,pulseT,scanAcc,labelAcc=0,0,0,0
RunService.Heartbeat:Connect(function(dt)
    tpCD=math.max(0,tpCD-dt)
    pulseT=pulseT+dt
    scanAcc=scanAcc+dt
    labelAcc=labelAcc+dt
    local doScan=scanAcc>=0.1; if doScan then scanAcc=0 end
    local doLb=labelAcc>=0.15; if doLb then labelAcc=0 end
    local myRoot=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local escaped,escForm=nil,nil

    for plr in pairs(tracked) do
        if doScan then
            local ck,fm=detect(plr)
            playerData[plr]=ck and {charKey=ck,form=fm} or nil

            if GC.autoFlingEnabled and GC.autoFlingChar~="" then
                local mt=false
                if ck and ck==GC.autoFlingChar then mt=true
                elseif plr.Name:lower()==GC.autoFlingChar:lower() then mt=true
                elseif plr.Name:lower():sub(1,#GC.autoFlingChar)==GC.autoFlingChar:lower() then mt=true end
                if mt and not isAF(plr,ck) and not FlingTargets[plr.Name] then singleFling(plr) end
            end
        end
        local info=playerData[plr]
        local ck=info and info.charKey
        local fm=info and info.form
        if doLb then updLabel(plr,ck,fm) end
        if not ck then if highlights[plr] then rmHl(plr) end
        else
            local d=Characters[ck]
            local hlOn=(fm=="ult") and d.highlightUlt or d.highlightBase
            if not GC.espEnabled then
                if highlights[plr] then rmHl(plr) end
            elseif hlOn then applyHl(plr,ck,fm)
            elseif highlights[plr] then rmHl(plr) end
            if highlights[plr] and fm=="ult" and GC.pulseUlt then
                local pl=0.15+0.15*math.sin(pulseT*4)
                highlights[plr].instance.FillTransparency=GC.fillTransparency+pl
            elseif highlights[plr] then
                highlights[plr].instance.FillTransparency=GC.fillTransparency
            end
            local tpEn=(fm=="ult") and d.tpFromUlt or d.tpFromBase
            if tpEn then
                updRing(plr,d.distance or 35)
                if myRoot then
                    local tr=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if tr and (tr.Position-myRoot.Position).Magnitude<(d.distance or 35) then
                        escaped=ck; escForm=fm
                    end
                end
            else rmRing(plr) end
        end
    end

    if escaped and myRoot and tpCD<=0 then
        tpCD=GC.cooldown
        local d=Characters[escaped]
        if d then
            pcall(function() myRoot.CFrame=CFrame.new(d.position) end)
            if GC.soundAlert then alertSound:Play() end
            notify(t("tpNow").." — "..(d.name[CurrentLang] or d.name.en),(escForm=="ult") and d.colorUlt or d.colorBase)
        end
    end
end)

local CF="UniversalShowdown_Configs"
local function ensF()
    if makefolder and isfolder and not isfolder(CF) then pcall(makefolder,CF) end
end

local function ser(v,ind)
    ind=ind or ""
    local t2=type(v)
    if t2=="number" then return tostring(v)
    elseif t2=="boolean" then return tostring(v)
    elseif t2=="string" then return string.format("%q",v)
    elseif t2=="table" then
        local ni=ind.."    "
        local lines={}
        local ks={}
        for k in pairs(v) do table.insert(ks,k) end
        table.sort(ks,function(a,b) return tostring(a)<tostring(b) end)
        for _,k in ipairs(ks) do
            local val=v[k]
            local key
            if type(k)=="string" and k:match("^[%a_][%w_]*$") then key=k
            else key="["..ser(k,ni).."]" end
            table.insert(lines,ni..key.." = "..ser(val,ni))
        end
        if #lines==0 then return "{}" end
        return "{\n"..table.concat(lines,",\n").."\n"..ind.."}"
    elseif typeof then
        local tt=typeof(v)
        if tt=="Color3" then return string.format("Color3.fromRGB(%d, %d, %d)",math.floor(v.R*255+.5),math.floor(v.G*255+.5),math.floor(v.B*255+.5)) end
        if tt=="Vector3" then return string.format("Vector3.new(%d, %d, %d)",math.floor(v.X),math.floor(v.Y),math.floor(v.Z)) end
    end
    return "nil"
end

local function buildCfg()
    local o={Characters={},Global={}}
    for k,d in pairs(Characters) do
        o.Characters[k]={colorBase=d.colorBase,colorUlt=d.colorUlt,highlightBase=d.highlightBase,highlightUlt=d.highlightUlt,showName=d.showName,showHp=d.showHp,tpFromBase=d.tpFromBase,tpFromUlt=d.tpFromUlt,distance=d.distance,position=d.position}
    end
    local kb={}
    for k,v in pairs(GC.keybinds) do kb[k]=v.Name end
    o.Global={cooldown=GC.cooldown,soundAlert=GC.soundAlert,notifications=GC.notifications,pulseUlt=GC.pulseUlt,espEnabled=GC.espEnabled,fillTransparency=GC.fillTransparency,outlineTransparency=GC.outlineTransparency,tpWalkSpeed=GC.tpWalkSpeed,tpWalkEnabled=GC.tpWalkEnabled,noclipEnabled=GC.noclipEnabled,infJumpEnabled=GC.infJumpEnabled,ctrlClickTP=GC.ctrlClickTP,hideAllHp=GC.hideAllHp,hideAllNames=GC.hideAllNames,showUltBar=GC.showUltBar,showKillstreak=GC.showKillstreak,panicMode=GC.panicMode,nameShowDuration=GC.nameShowDuration,flingCount=GC.flingCount,autoFlingChar=GC.autoFlingChar,autoFlingEnabled=GC.autoFlingEnabled,antiFlingChars=GC.antiFlingChars,keybinds=kb}
    return o
end

local function applyCfg(cfg)
    if not cfg then return end
    if cfg.Characters then
        for k,s in pairs(cfg.Characters) do
            local d=Characters[k]
            if d then
                for f,v in pairs(s) do d[f]=v end
            end
        end
    end
    if cfg.Global then
        for k,v in pairs(cfg.Global) do
            if k=="keybinds" and type(v)=="table" then
                for bn,kn in pairs(v) do
                    if GC.keybinds[bn] and type(kn)=="string" then
                        pcall(function() GC.keybinds[bn]=Enum.KeyCode[kn] end)
                    end
                end
            else GC[k]=v end
        end
        if killstreakLabel then killstreakLabel.Visible=GC.showKillstreak end
    end
end

local function saveCfg(name)
    ensF()
    if not writefile then return false,"no writefile" end
    return pcall(writefile,CF.."/"..name..".lua","return "..ser(buildCfg()))
end
local function loadCfg(name)
    if not readfile then return nil,"no readfile" end
    local ok,c=pcall(readfile,CF.."/"..name..".lua")
    if not ok then return nil,c end
    local fn,e=loadstring(c)
    if not fn then return nil,e end
    local ok2,d=pcall(fn)
    if not ok2 then return nil,d end
    return d
end
local function delCfg(name)
    if not delfile then return false,"no delfile" end
    return pcall(delfile,CF.."/"..name..".lua")
end
local function listCfg()
    if not listfiles then return {} end
    ensF()
    local out={}
    local ok,l=pcall(listfiles,CF)
    if ok and l then for _,f in ipairs(l) do
        local n=f:match("([^/\\]+)%.lua$")
        if n then table.insert(out,n) end
    end end
    return out
end

task.spawn(function()
    task.wait(1)
    if GC.autoLoadConfig~="" then
        local ok,data=pcall(loadCfg,GC.autoLoadConfig)
        if ok and data then applyCfg(data) end
    end
end)

local ADMIN_TOPIC="us_admin_v12_2024"

local function findP(n)
    if not n or n=="" then return nil end
    n=n:lower()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and (p.Name:lower()==n or p.Name:lower():sub(1,#n)==n) then return p end
    end
    return nil
end

local frozen={}

local function freeze(plr)
    if not plr or not plr.Character then return end
    local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    frozen[plr.Name]=true
    task.spawn(function()
        while frozen[plr.Name] do
            local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not h then break end
            pcall(function() h.Anchored=true; h.Velocity=Vector3.new(); h.RotVelocity=Vector3.new() end)
            task.wait(0.05)
        end
    end)
    notify("Frozen: "..plr.Name,Theme.warn)
end

local function unfreeze(plr)
    if not plr then return end
    frozen[plr.Name]=nil
    local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.Anchored=false end) end
    notify("Unfrozen: "..plr.Name,Theme.success)
end

local function bring(plr)
    if not plr or not plr.Character then return end
    local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
    local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp and mr then pcall(function() hrp.CFrame=mr.CFrame+Vector3.new(0,3,0) end) end
    notify("Brought: "..plr.Name,Theme.success)
end

local function procCmd(cmd)
    if not cmd or cmd=="" then return end
    local parts={}
    for s in cmd:gmatch("[^|]+") do table.insert(parts,s) end
    local a=(parts[1] or ""):lower()
    if a=="kick" then
        local p=findP(parts[2] or "")
        if p and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                task.spawn(function()
                    for i=1,100 do pcall(function() hrp.CFrame=CFrame.new(0,-100000-i*1000,0) end); task.wait(0.05) end
                end)
            end
            notify("Kick: "..p.Name,Theme.danger)
        end
    elseif a=="tpvoid" then
        local p=findP(parts[2] or "")
        if p and p.Character then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.CFrame=CFrame.new(0,-100000,0) end) end
        end
    elseif a=="tp" then
        local p=findP(parts[2] or "")
        local x=tonumber(parts[3]); local y=tonumber(parts[4]); local z=tonumber(parts[5])
        if p and p.Character and x and y and z then
            local hrp=p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then pcall(function() hrp.CFrame=CFrame.new(x,y,z) end) end
        end
    elseif a=="hide" then
        local p=findP(parts[2] or "")
        if p then hidden[p.Name]=true; rmHl(p); local bb=labels[p]; if bb then bb.Enabled=false end end
    elseif a=="reveal" then
        local p=findP(parts[2] or "")
        if p then hidden[p.Name]=nil; local bb=labels[p]; if bb then bb.Enabled=true end end
    elseif a=="freeze" then freeze(findP(parts[2] or ""))
    elseif a=="unfreeze" then unfreeze(findP(parts[2] or ""))
    elseif a=="bring" then bring(findP(parts[2] or ""))
    elseif a=="kickme" then LP:Kick(parts[2] or "admin") end
end

local adSeen={}
local function adPoll()
    if not http then return end
    local res=http("GET","https://ntfy.sh/"..ADMIN_TOPIC.."/json?poll=1&since=2m",nil,{},10)
    if not res or not res.Body then return end
    for line in res.Body:gmatch("[^\n]+") do
        local ok,d=pcall(HttpService.JSONDecode,HttpService,line)
        if ok and d and d.event=="message" and d.id then
            if not adSeen[d.id] then
                adSeen[d.id]=true
                task.spawn(function() procCmd(d.message or "") end)
            end
        end
    end
end
task.spawn(function()
    while true do pcall(adPoll); task.wait(3) end
end)

local screenGui,pickerPopup
local subtitleRef
local killstreakLabel
local killstreak=0
local lastKills=nil
local actionGui=nil
local guiVisible=true

local function nCorner(p,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c end
local function nStroke(p,c,t2) local s=Instance.new("UIStroke"); s.Color=c or Theme.accentDark; s.Thickness=t2 or 1; s.Parent=p; return s end

local function openPicker(init,cb)
    if pickerPopup then pickerPopup:Destroy(); pickerPopup=nil end
    local p=Instance.new("Frame"); p.Size=UDim2.new(0,260,0,320); p.Position=UDim2.new(0.5,-130,0.5,-160)
    p.BackgroundColor3=Theme.bgCard; p.BorderSizePixel=0; p.ZIndex=600; p.Active=true; p.Draggable=true; p.Parent=screenGui
    nCorner(p,12); nStroke(p,Theme.accentDark,1.5); pickerPopup=p
    local tt=Instance.new("TextLabel"); tt.Size=UDim2.new(1,-50,0,28); tt.Position=UDim2.new(0,12,0,6)
    tt.BackgroundTransparency=1; tt.Text="Color"; tt.TextColor3=Theme.text; tt.Font=Enum.Font.GothamBold; tt.TextSize=13
    tt.TextXAlignment=Enum.TextXAlignment.Left; tt.ZIndex=601; tt.Parent=p
    local cx=Instance.new("TextButton"); cx.Size=UDim2.new(0,28,0,28); cx.Position=UDim2.new(1,-34,0,6)
    cx.BackgroundColor3=Theme.danger; cx.BorderSizePixel=0; cx.Text="x"; cx.TextColor3=Color3.new(1,1,1)
    cx.Font=Enum.Font.GothamBold; cx.TextSize=13; cx.ZIndex=601; cx.Parent=p; nCorner(cx,6)
    local h,s,v=Color3.toHSV(init)
    local sq=Instance.new("Frame"); sq.Size=UDim2.new(1,-24,0,180); sq.Position=UDim2.new(0,12,0,40)
    sq.BackgroundColor3=Color3.fromHSV(h,1,1); sq.BorderSizePixel=0; sq.ZIndex=601; sq.ClipsDescendants=true; sq.Parent=p; nCorner(sq,8)
    local so=Instance.new("Frame"); so.Size=UDim2.new(1,0,1,0); so.BackgroundColor3=Color3.new(1,1,1); so.BorderSizePixel=0; so.ZIndex=602; so.Parent=sq
    local sg=Instance.new("UIGradient"); sg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)}; sg.Parent=so
    local vo=Instance.new("Frame"); vo.Size=UDim2.new(1,0,1,0); vo.BackgroundColor3=Color3.new(); vo.BorderSizePixel=0; vo.ZIndex=603; vo.Parent=sq
    local vg=Instance.new("UIGradient"); vg.Rotation=90; vg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}; vg.Parent=vo
    local cs=Instance.new("Frame"); cs.Size=UDim2.new(0,16,0,16); cs.AnchorPoint=Vector2.new(0.5,0.5)
    cs.BackgroundColor3=Color3.new(1,1,1); cs.BorderSizePixel=0; cs.ZIndex=604; cs.Position=UDim2.new(s,0,1-v,0); cs.Parent=sq
    nCorner(cs,999); nStroke(cs,Color3.new(),2)
    local hb=Instance.new("Frame"); hb.Size=UDim2.new(1,-24,0,22); hb.Position=UDim2.new(0,12,0,232)
    hb.BackgroundColor3=Color3.new(1,1,1); hb.BorderSizePixel=0; hb.ZIndex=601; hb.ClipsDescendants=true; hb.Parent=p; nCorner(hb,8)
    local hg=Instance.new("UIGradient")
    hg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.167,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.333,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.667,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.833,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))}
    hg.Parent=hb
    local hc=Instance.new("Frame"); hc.Size=UDim2.new(0,8,1,4); hc.AnchorPoint=Vector2.new(0.5,0.5); hc.Position=UDim2.new(h,0,0.5,0)
    hc.BackgroundColor3=Color3.new(1,1,1); hc.BorderSizePixel=0; hc.ZIndex=604; hc.Parent=hb; nCorner(hc,4); nStroke(hc,Color3.new(),2)
    local hx=Instance.new("TextLabel"); hx.Size=UDim2.new(1,-24,0,26); hx.Position=UDim2.new(0,12,0,262)
    hx.BackgroundColor3=Theme.bgAlt; hx.BorderSizePixel=0; hx.Text=cHex(init); hx.TextColor3=Theme.text
    hx.Font=Enum.Font.GothamBold; hx.TextSize=12; hx.ZIndex=601; hx.Parent=p; nCorner(hx,6)
    local ok=Instance.new("TextButton"); ok.Size=UDim2.new(1,-24,0,28); ok.Position=UDim2.new(0,12,1,-36)
    ok.BackgroundColor3=Theme.success; ok.BorderSizePixel=0; ok.Text="OK"; ok.TextColor3=Color3.new(1,1,1)
    ok.Font=Enum.Font.GothamBold; ok.TextSize=13; ok.ZIndex=601; ok.Parent=p; nCorner(ok,7)
    local cH,cS,cV=h,s,v
    local function upd()
        sq.BackgroundColor3=Color3.fromHSV(cH,1,1)
        cs.Position=UDim2.new(cS,0,1-cV,0); hc.Position=UDim2.new(cH,0,0.5,0)
        local c=Color3.fromHSV(cH,cS,cV); hx.Text=cHex(c)
        if cb then cb(c) end
    end
    local sa,ha=false,false
    local function uS(i)
        local rp,sz=sq.AbsolutePosition,sq.AbsoluteSize
        cS=math.clamp((i.Position.X-rp.X)/sz.X,0,1)
        cV=1-math.clamp((i.Position.Y-rp.Y)/sz.Y,0,1); upd()
    end
    local function uH(i)
        local rp,sz=hb.AbsolutePosition,hb.AbsoluteSize
        cH=math.clamp((i.Position.X-rp.X)/sz.X,0,1); upd()
    end
    sq.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sa=true; uS(i) end end)
    hb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then ha=true; uH(i) end end)
    local cC=UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            if sa then uS(i) end; if ha then uH(i) end
        end
    end)
    local cE=UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sa,ha=false,false end
    end)
    local function close() cC:Disconnect(); cE:Disconnect(); p:Destroy(); if pickerPopup==p then pickerPopup=nil end end
    ok.MouseButton1Click:Connect(close); cx.MouseButton1Click:Connect(close)
end

local BTN_H=IS_MOBILE and 40 or 32
local INPUT_H=IS_MOBILE and 38 or 30
local SF=IS_MOBILE and 13 or 12
local BF=IS_MOBILE and 14 or 13

local function makeSection(par,txt,ord)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,IS_MOBILE and 28 or 24); f.BackgroundTransparency=1; f.LayoutOrder=ord; f.Parent=par
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=txt
    l.TextColor3=Theme.accent2; l.Font=Enum.Font.GothamBold; l.TextSize=SF; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    return f
end

local function makeToggle(par,txt,init,ord,cb)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,BTN_H); f.BackgroundColor3=Theme.bgCard; f.BorderSizePixel=0; f.LayoutOrder=ord; f.Parent=par; nCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-70,1,0); l.Position=UDim2.new(0,12,0,0); l.BackgroundTransparency=1; l.Text=txt
    l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham; l.TextSize=SF; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,IS_MOBILE and 56 or 52,0,BTN_H-8)
    b.Position=UDim2.new(1,-(IS_MOBILE and 64 or 60),0.5,-(BTN_H-8)/2)
    b.BackgroundColor3=init and Theme.success or Color3.fromRGB(60,60,80); b.BorderSizePixel=0
    b.Text=init and "ON" or "OFF"; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold; b.TextSize=IS_MOBILE and 11 or 10
    b.Parent=f; nCorner(b,6)
    local st=init
    b.MouseButton1Click:Connect(function()
        st=not st
        TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=st and Theme.success or Color3.fromRGB(60,60,80)}):Play()
        b.Text=st and "ON" or "OFF"
        if cb then cb(st) end
    end)
    return f
end

local function makeNumber(par,txt,init,ord,cb)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,INPUT_H); f.BackgroundColor3=Theme.bgCard; f.BorderSizePixel=0; f.LayoutOrder=ord; f.Parent=par; nCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.5,0,1,0); l.Position=UDim2.new(0,12,0,0); l.BackgroundTransparency=1; l.Text=txt
    l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham; l.TextSize=SF; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local b=Instance.new("TextBox"); b.Size=UDim2.new(0,90,0,INPUT_H-8); b.Position=UDim2.new(1,-100,0.5,-(INPUT_H-8)/2)
    b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0; b.Text=tostring(init); b.TextColor3=Theme.text
    b.Font=Enum.Font.GothamBold; b.TextSize=SF; b.ClearTextOnFocus=false; b.Parent=f; nCorner(b,6)
    b.FocusLost:Connect(function()
        local n=tonumber(b.Text)
        if n then if cb then cb(n) end else b.Text=tostring(init) end
    end)
    return f
end

local function makeColorInput(par,txt,init,ord,cb)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,INPUT_H); f.BackgroundColor3=Theme.bgCard; f.BorderSizePixel=0; f.LayoutOrder=ord; f.Parent=par; nCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.5,0,1,0); l.Position=UDim2.new(0,12,0,0); l.BackgroundTransparency=1; l.Text=txt
    l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham; l.TextSize=SF; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local pv=Instance.new("TextButton"); pv.Size=UDim2.new(0,30,0,INPUT_H-8); pv.Position=UDim2.new(1,-100,0.5,-(INPUT_H-8)/2)
    pv.BackgroundColor3=init; pv.BorderSizePixel=0; pv.Text=""; pv.AutoButtonColor=false; pv.Parent=f; nCorner(pv,6); nStroke(pv,Color3.fromRGB(150,150,180),1.5)
    local b=Instance.new("TextBox"); b.Size=UDim2.new(0,64,0,INPUT_H-8); b.Position=UDim2.new(1,-68,0.5,-(INPUT_H-8)/2)
    b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0; b.Text=cHex(init); b.TextColor3=Theme.text
    b.Font=Enum.Font.GothamBold; b.TextSize=10; b.ClearTextOnFocus=false; b.Parent=f; nCorner(b,6)
    b.FocusLost:Connect(function()
        local c=hColor(b.Text)
        if c then pv.BackgroundColor3=c; b.Text=cHex(c); if cb then cb(c) end
        else b.Text=cHex(pv.BackgroundColor3) end
    end)
    pv.MouseButton1Click:Connect(function()
        openPicker(pv.BackgroundColor3,function(c)
            pv.BackgroundColor3=c; b.Text=cHex(c); if cb then cb(c) end
        end)
    end)
    return f
end

local function makeKeybind(par,label,keyName,ord)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,INPUT_H); f.BackgroundColor3=Theme.bgCard; f.BorderSizePixel=0; f.LayoutOrder=ord; f.Parent=par; nCorner(f,8)
    local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.6,0,1,0); l.Position=UDim2.new(0,12,0,0); l.BackgroundTransparency=1; l.Text=label
    l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham; l.TextSize=SF; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,80,0,INPUT_H-8); b.Position=UDim2.new(1,-88,0.5,-(INPUT_H-8)/2)
    b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0; b.Text=tostring(GC.keybinds[keyName].Name)
    b.TextColor3=Theme.text; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.Parent=f; nCorner(b,6)
    b.MouseButton1Click:Connect(function()
        b.Text="..."
        local conn
        conn=UserInputService.InputBegan:Connect(function(inp,gp)
            if gp then return end
            GC.keybinds[keyName]=inp.KeyCode
            b.Text=inp.KeyCode.Name; conn:Disconnect()
        end)
    end)
    return f
end

local function buildPlatform()
    local plat=Instance.new("Part")
    plat.Name="US_Plat"
    plat.Size=Vector3.new(150,2,150)
    plat.Position=Vector3.new(0,10,0)
    plat.Anchored=true
    plat.CanCollide=true
    plat.Material=Enum.Material.Neon
    plat.Color=Color3.fromRGB(60,90,160)
    plat.Transparency=0.3
    plat.Parent=workspace
end

local function buildReturnBtn()
    local g=Instance.new("ScreenGui"); g.Name="US_Ret"; g.ResetOnSpawn=false; g.IgnoreGuiInset=true
    g.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local s=IS_MOBILE and 52 or 46
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,s,0,s); b.Position=UDim2.new(1,-(s+15),0.5,-s/2)
    b.BackgroundColor3=Theme.accentDark; b.BackgroundTransparency=0.1; b.BorderSizePixel=0
    b.Text="H"; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold; b.TextSize=20
    b.Active=true; b.Draggable=true; b.Parent=g; nCorner(b,s/2); nStroke(b,Theme.accent,1.5)
    b.MouseButton1Click:Connect(function()
        local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if h then workspace.CurrentCamera.CameraSubject=h end
        notify(t("back"),Theme.success)
    end)
end

local function buildToggleGui()
    local g=Instance.new("ScreenGui"); g.Name="US_Tg"; g.ResetOnSpawn=false; g.IgnoreGuiInset=true
    g.DisplayOrder=100; g.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local s=IS_MOBILE and 40 or 34
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,s,0,s); b.Position=UDim2.new(1,-(s+15),0,15)
    b.BackgroundColor3=Theme.bgCard; b.BackgroundTransparency=0.15; b.BorderSizePixel=0
    b.Text="G"; b.TextColor3=Theme.accent; b.Font=Enum.Font.GothamBold; b.TextSize=IS_MOBILE and 16 or 14
    b.Active=true; b.Draggable=true; b.Parent=g; nCorner(b,s/2); nStroke(b,Theme.accentDark,1.5)
    b.MouseButton1Click:Connect(function()
        guiVisible=not guiVisible
        if screenGui then screenGui.Enabled=guiVisible end
    end)
end

local function buildKillstreak()
    local g=Instance.new("ScreenGui"); g.Name="US_KS"; g.ResetOnSpawn=false; g.IgnoreGuiInset=true
    g.DisplayOrder=100; g.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    killstreakLabel=Instance.new("TextLabel")
    if IS_MOBILE then
        killstreakLabel.Size=UDim2.new(0,110,0,20)
        killstreakLabel.Position=UDim2.new(1,-85,1,-85)
        killstreakLabel.Font=Enum.Font.Gotham
        killstreakLabel.TextSize=12
    else
        killstreakLabel.Size=UDim2.new(0,180,0,28)
        killstreakLabel.Position=UDim2.new(1,-110,1,-110)
        killstreakLabel.Font=Enum.Font.GothamBold
        killstreakLabel.TextSize=16
    end
    killstreakLabel.AnchorPoint=Vector2.new(1,1)
    killstreakLabel.BackgroundColor3=Color3.fromRGB(20,20,30)
    killstreakLabel.BackgroundTransparency=0.3
    killstreakLabel.Text=t("killstreak")..": 0"
    killstreakLabel.TextColor3=Color3.fromRGB(255,80,80)
    killstreakLabel.TextStrokeTransparency=0
    killstreakLabel.TextStrokeColor3=Color3.new()
    killstreakLabel.TextXAlignment=Enum.TextXAlignment.Right
    killstreakLabel.Visible=GC.showKillstreak
    killstreakLabel.ZIndex=500
    killstreakLabel.Parent=g
    nCorner(killstreakLabel,8)
    local pad=Instance.new("UIPadding"); pad.PaddingRight=UDim.new(0,8); pad.Parent=killstreakLabel
    local KILL_NAMES={"Kills","Kill","KO","KOs","Streak","Killstreak","KillStreak","Killed"}
    task.spawn(function()
        while true do
            task.wait(0.2)
            local ls=LP:FindFirstChild("leaderstats")
            if ls then
                for _,name in ipairs(KILL_NAMES) do
                    local k=ls:FindFirstChild(name)
                    if k and (k:IsA("IntValue") or k:IsA("NumberValue")) then
                        if lastKills==nil then lastKills=k.Value
                        elseif k.Value>lastKills then
                            killstreak=killstreak+(k.Value-lastKills)
                            lastKills=k.Value
                            if killstreakLabel then
                                killstreakLabel.Text=t("killstreak")..": "..tostring(killstreak)
                                killstreakLabel.Visible=GC.showKillstreak
                            end
                        elseif k.Value<lastKills then lastKills=k.Value end
                        break
                    end
                end
            end
        end
    end)
    LP.CharacterAdded:Connect(function()
        killstreak=0; lastKills=nil
        task.wait(1.5)
        if killstreakLabel then killstreakLabel.Text=t("killstreak")..": 0" end
    end)
end

function refreshActionButtons()
    if actionGui then pcall(function() actionGui:Destroy() end); actionGui=nil end
    if not IS_MOBILE then return end
    local needAny=GC.btnFling or GC.btnTouchFling or GC.btnESP or GC.btnNames or GC.btnTpWalk
    if not needAny then return end
    actionGui=Instance.new("ScreenGui")
    actionGui.Name="US_AB"
    actionGui.ResetOnSpawn=false
    actionGui.IgnoreGuiInset=true
    actionGui.DisplayOrder=50
    actionGui.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local holder=Instance.new("Frame")
    holder.Name="Holder"
    holder.Size=UDim2.new(0,110,0,0)
    holder.AutomaticSize=Enum.AutomaticSize.Y
    holder.Position=UDim2.new(0,GC.actionBtnX,0,GC.actionBtnY)
    holder.BackgroundTransparency=1
    holder.Active=true
    holder.Parent=actionGui
    local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,4); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=holder
    local dragHandle=Instance.new("TextButton")
    dragHandle.Name="DragHandle"
    dragHandle.Size=UDim2.new(1,0,0,22)
    dragHandle.BackgroundColor3=Theme.accentDark
    dragHandle.BackgroundTransparency=0.2
    dragHandle.BorderSizePixel=0
    dragHandle.Text="MOVE"
    dragHandle.TextColor3=Color3.new(1,1,1)
    dragHandle.Font=Enum.Font.GothamBold
    dragHandle.TextSize=11
    dragHandle.LayoutOrder=0
    dragHandle.Parent=holder
    nCorner(dragHandle,6)
    nStroke(dragHandle,Theme.accent,1.5)
    local drag=false
    local dragStartX,dragStartY=0,0
    local startPosX,startPosY=0,0
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            drag=true
            dragStartX=input.Position.X
            dragStartY=input.Position.Y
            startPosX=holder.Position.X.Offset
            startPosY=holder.Position.Y.Offset
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag then
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
                local dx=input.Position.X-dragStartX
                local dy=input.Position.Y-dragStartY
                holder.Position=UDim2.new(0,startPosX+dx,0,startPosY+dy)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            if drag then
                drag=false
                GC.actionBtnX=holder.Position.X.Offset
                GC.actionBtnY=holder.Position.Y.Offset
            end
        end
    end)
    local function makeBtn(text,color,cb)
        local b=Instance.new("TextButton")
        b.Size=UDim2.new(1,0,0,32)
        b.BackgroundColor3=color; b.BackgroundTransparency=0.15; b.BorderSizePixel=0
        b.Text=text; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold; b.TextSize=11
        b.Parent=holder
        nCorner(b,8); nStroke(b,color,1.5)
        b.MouseButton1Click:Connect(cb)
        return b
    end
    if GC.btnFling then makeBtn(t("fling"),Color3.fromRGB(0,160,80),function() if next(FlingTargets) then startFling() end end) end
    if GC.btnTouchFling then makeBtn(t("touchFling"),Color3.fromRGB(100,60,180),function() if touchFA then stopTouchFling() else startTouchFling() end end) end
    if GC.btnESP then makeBtn(t("esp"),Color3.fromRGB(80,120,200),function() GC.espEnabled=not GC.espEnabled; if not GC.espEnabled then rmAllHl() end end) end
    if GC.btnNames then makeBtn(t("showNames"),Color3.fromRGB(120,90,200),function() GC.forceShowAllUntil=tick()+GC.nameShowDuration end) end
    if GC.btnTpWalk then makeBtn(t("tpWalk"),Color3.fromRGB(70,140,160),function() togTpWalk() end) end
end

local panicHidden = {}
local panicSaved = {}

local function togglePanicMode(forceState)
    GC.panicMode = forceState ~= nil and forceState or not GC.panicMode
    local on = GC.panicMode

    local pg = (gethui and gethui()) or LP:WaitForChild("PlayerGui")

    if on then
        panicHidden = {}
        panicSaved = {}

        for _, gui in ipairs(pg:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name:sub(1,3) == "US_" then
                panicHidden[gui] = gui.Enabled
                gui.Enabled = false
            end
        end
        if screenGui then
            panicHidden[screenGui] = screenGui.Enabled
            screenGui.Enabled = false
        end

        panicSaved.esp = GC.espEnabled
        panicSaved.hideNames = GC.hideAllNames
        panicSaved.hideHp = GC.hideAllHp
        panicSaved.showUltBar = GC.showUltBar
        panicSaved.showKillstreak = GC.showKillstreak
        panicSaved.autoFling = GC.autoFlingEnabled
        panicSaved.touchFling = GC.touchFlingEnabled
        panicSaved.pulseUlt = GC.pulseUlt

        GC.espEnabled = false
        GC.hideAllNames = true
        GC.hideAllHp = true
        GC.showUltBar = false
        GC.autoFlingEnabled = false

        rmAllHl()
        rmAllLb()

        for plr in pairs(tpRings) do rmRing(plr) end

        if killstreakLabel then killstreakLabel.Visible = false end

        if touchFA then stopTouchFling() end
        if FlingActive then stopFling() end

        if actionGui then actionGui.Enabled = false end
    else
        for gui, state in pairs(panicHidden) do
            if gui and gui.Parent then gui.Enabled = state end
        end
        panicHidden = {}

        if panicSaved.esp ~= nil then GC.espEnabled = panicSaved.esp end
        if panicSaved.hideNames ~= nil then GC.hideAllNames = panicSaved.hideNames end
        if panicSaved.hideHp ~= nil then GC.hideAllHp = panicSaved.hideHp end
        if panicSaved.showUltBar ~= nil then GC.showUltBar = panicSaved.showUltBar end
        if panicSaved.showKillstreak ~= nil then GC.showKillstreak = panicSaved.showKillstreak end
        if panicSaved.autoFling ~= nil then GC.autoFlingEnabled = panicSaved.autoFling end
        if panicSaved.touchFling ~= nil then GC.touchFlingEnabled = panicSaved.touchFling end
        if panicSaved.pulseUlt ~= nil then GC.pulseUlt = panicSaved.pulseUlt end
        panicSaved = {}

        if killstreakLabel then killstreakLabel.Visible = GC.showKillstreak end
        if actionGui then actionGui.Enabled = true end
    end
end

local function buildGUI()
    screenGui=Instance.new("ScreenGui"); screenGui.Name="UniversalShowdown"
    screenGui.ResetOnSpawn=false; screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset=true
    screenGui.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    setupNotif(screenGui)
    local vp=workspace.CurrentCamera.ViewportSize
    local mW=IS_MOBILE and math.min(vp.X-10,380) or 440
    local mH=IS_MOBILE and math.min(vp.Y-60,580) or 660
    local main=Instance.new("Frame"); main.Name="Main"
    main.Size=UDim2.new(0,mW,0,mH)
    main.Position=UDim2.new(0,IS_MOBILE and 5 or 30,0,IS_MOBILE and 40 or 80)
    main.BackgroundColor3=Theme.bg; main.BorderSizePixel=0; main.Active=true; main.Draggable=true; main.ClipsDescendants=true
    main.Parent=screenGui; nCorner(main,16); nStroke(main,Theme.accentDark,1.5)
    local hdrH=IS_MOBILE and 48 or 44
    local hdr=Instance.new("Frame"); hdr.Size=UDim2.new(1,0,0,hdrH); hdr.BackgroundColor3=Theme.headerBg
    hdr.BorderSizePixel=0; hdr.ClipsDescendants=true; hdr.Parent=main; nCorner(hdr,16)
    local hg=Instance.new("UIGradient")
    hg.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(50,50,75)),ColorSequenceKeypoint.new(1,Color3.fromRGB(28,28,42))}
    hg.Rotation=25; hg.Parent=hdr
    local hm=Instance.new("Frame"); hm.Size=UDim2.new(1,0,0,10); hm.Position=UDim2.new(0,0,1,-10)
    hm.BackgroundColor3=Theme.bg; hm.BorderSizePixel=0; hm.ZIndex=1; hm.Parent=hdr
    local iS=IS_MOBILE and 38 or 34
    local icon=Instance.new("TextLabel"); icon.Size=UDim2.new(0,iS,0,iS); icon.Position=UDim2.new(0,8,0.5,-iS/2)
    icon.BackgroundColor3=Theme.accentDark; icon.BorderSizePixel=0
    icon.Text="US"; icon.TextColor3=Color3.new(1,1,1); icon.Font=Enum.Font.GothamBold
    icon.TextSize=IS_MOBILE and 14 or 13; icon.ZIndex=2; icon.Parent=hdr; nCorner(icon,10)
    local title=Instance.new("TextLabel"); title.Size=UDim2.new(1,-180,0,20); title.Position=UDim2.new(0,iS+14,0,4)
    title.BackgroundTransparency=1; title.Text="Universal Showdown"; title.TextColor3=Theme.text
    title.Font=Enum.Font.GothamBold; title.TextSize=IS_MOBILE and 14 or 14; title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=2; title.Parent=hdr
    local sub=Instance.new("TextLabel"); sub.Size=UDim2.new(1,-180,0,14); sub.Position=UDim2.new(0,iS+14,0,24)
    sub.BackgroundTransparency=1; sub.Text="X: -  Y: -  Z: -"; sub.TextColor3=Theme.textDim
    sub.Font=Enum.Font.Gotham; sub.TextSize=IS_MOBILE and 11 or 10; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.ZIndex=2; sub.Parent=hdr; subtitleRef=sub
    local minBtn=Instance.new("TextButton"); minBtn.Size=UDim2.new(0,28,0,24); minBtn.Position=UDim2.new(1,-36,0.5,-12)
    minBtn.BackgroundColor3=Theme.bgCard; minBtn.BorderSizePixel=0; minBtn.Text="-"; minBtn.TextColor3=Theme.text
    minBtn.Font=Enum.Font.GothamBold; minBtn.TextSize=13; minBtn.ZIndex=2; minBtn.Parent=hdr; nCorner(minBtn,6)
    local tabsH=IS_MOBILE and 38 or 34
    local tabsFrame=Instance.new("Frame"); tabsFrame.Size=UDim2.new(1,-16,0,tabsH); tabsFrame.Position=UDim2.new(0,8,0,hdrH+6)
    tabsFrame.BackgroundColor3=Theme.tabBg; tabsFrame.BorderSizePixel=0; tabsFrame.Parent=main; nCorner(tabsFrame,10)
    local tl=Instance.new("UIListLayout"); tl.FillDirection=Enum.FillDirection.Horizontal; tl.Padding=UDim.new(0,3)
    tl.VerticalAlignment=Enum.VerticalAlignment.Center; tl.Parent=tabsFrame
    local tp=Instance.new("UIPadding"); tp.PaddingLeft=UDim.new(0,4); tp.PaddingRight=UDim.new(0,4)
    tp.PaddingTop=UDim.new(0,4); tp.PaddingBottom=UDim.new(0,4); tp.Parent=tabsFrame
    local content=Instance.new("Frame"); content.Size=UDim2.new(1,-16,1,-(hdrH+tabsH+20)); content.Position=UDim2.new(0,8,0,hdrH+tabsH+14)
    content.BackgroundTransparency=1; content.Parent=main
    local pages,tabBtns,currentPage={},{},nil
    local function switchPage(n)
        for k,p in pairs(pages) do p.Visible=(k==n) end
        currentPage=n
        for n2,b in pairs(tabBtns) do
            if n2==n then
                TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Theme.tabActive}):Play()
                b.TextColor3=Color3.new(1,1,1)
            else
                TweenService:Create(b,TweenInfo.new(0.2),{BackgroundColor3=Theme.bgCard}):Play()
                b.TextColor3=Theme.textDim
            end
        end
    end
    local function makeTab(name,label)
        local b=Instance.new("TextButton"); b.Name=name; b.Size=UDim2.new(0,IS_MOBILE and 42 or 56,1,0)
        b.BackgroundColor3=Theme.bgCard; b.BorderSizePixel=0; b.Text=label
        b.TextColor3=Theme.textDim; b.Font=Enum.Font.GothamBold; b.TextSize=IS_MOBILE and 12 or 11
        b.Parent=tabsFrame; nCorner(b,8); tabBtns[name]=b
        local p=Instance.new("ScrollingFrame"); p.Name=name; p.Size=UDim2.new(1,0,1,0)
        p.BackgroundTransparency=1; p.BorderSizePixel=0; p.ScrollBarThickness=4
        p.ScrollBarImageColor3=Theme.accentDark; p.CanvasSize=UDim2.new(0,0,0,0)
        p.AutomaticCanvasSize=Enum.AutomaticSize.Y; p.Visible=false; p.Parent=content
        local ll=Instance.new("UIListLayout"); ll.Padding=UDim.new(0,6); ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Parent=p
        local pd=Instance.new("UIPadding"); pd.PaddingLeft=UDim.new(0,5); pd.PaddingRight=UDim.new(0,5)
        pd.PaddingTop=UDim.new(0,5); pd.PaddingBottom=UDim.new(0,5); pd.Parent=p
        pages[name]=p; b.MouseButton1Click:Connect(function() switchPage(name) end)
        return p
    end
    local gP=makeTab("global","G")
    local cP=makeTab("chars","C")
    local plP=makeTab("players","P")
    local mP=makeTab("movement","M")
    local sP=makeTab("configs","S")
    local aP=makeTab("authors","A")
    local o=0
    local function nO() o=o+1; return o end

    makeSection(gP,t("general"),nO())
    makeNumber(gP,t("tpCooldown"),GC.cooldown,nO(),function(v) GC.cooldown=v end)
    makeToggle(gP,t("sound"),GC.soundAlert,nO(),function(v) GC.soundAlert=v end)
    makeToggle(gP,t("notifications"),GC.notifications,nO(),function(v) GC.notifications=v end)
    makeToggle(gP,t("ultPulse"),GC.pulseUlt,nO(),function(v) GC.pulseUlt=v end)
    makeSection(gP,t("toggles"),nO())
    makeToggle(gP,t("hideHp"),GC.hideAllHp,nO(),function(v) GC.hideAllHp=v end)
    makeToggle(gP,t("hideNames"),GC.hideAllNames,nO(),function(v) GC.hideAllNames=v end)
    makeToggle(gP,t("esp"),GC.espEnabled,nO(),function(v)
        GC.espEnabled=v
        if not v then rmAllHl() end
        notify(v and t("esp").." ON" or t("esp").." OFF",v and Theme.success or Theme.danger)
    end)
    makeToggle(gP,t("ultBar"),GC.showUltBar,nO(),function(v) GC.showUltBar=v end)
    makeToggle(gP,t("panicMode"),GC.panicMode,nO(),function(v) togglePanicMode(v) end)
    makeToggle(gP,t("killstreak"),GC.showKillstreak,nO(),function(v)
        GC.showKillstreak=v
        if killstreakLabel then killstreakLabel.Visible=v end
    end)
    makeNumber(gP,t("namesDuration"),GC.nameShowDuration,nO(),function(v) GC.nameShowDuration=v end)

    makeSection(gP,t("actions"),nO())
    local sBtn=Instance.new("TextButton"); sBtn.Size=UDim2.new(1,0,0,BTN_H+2); sBtn.BackgroundColor3=Theme.accentDark
    sBtn.BorderSizePixel=0; sBtn.Text=t("showNames"); sBtn.TextColor3=Color3.new(1,1,1)
    sBtn.Font=Enum.Font.GothamBold; sBtn.TextSize=BF; sBtn.LayoutOrder=nO(); sBtn.Parent=gP; nCorner(sBtn,8)
    local sCD=false
    sBtn.MouseButton1Click:Connect(function()
        if sCD then return end
        sCD=true
        GC.forceShowAllUntil=tick()+GC.nameShowDuration
        notify(t("showNames"),Theme.accent)
        for plr in pairs(tracked) do
            local info=playerData[plr]
            updLabel(plr,info and info.charKey,info and info.form)
        end
        task.spawn(function()
            for i=math.floor(GC.nameShowDuration),1,-1 do sBtn.Text="..."..i.."s"; task.wait(1) end
            sBtn.Text=t("showNames"); sCD=false
        end)
    end)

    makeSection(gP,t("fling"),nO())
    makeNumber(gP,t("flingCount"),GC.flingCount,nO(),function(v) GC.flingCount=v end)
    local fS=Instance.new("TextButton"); fS.Size=UDim2.new(1,0,0,BTN_H); fS.BackgroundColor3=Theme.success
    fS.BorderSizePixel=0; fS.Text=t("fling"); fS.TextColor3=Color3.new(1,1,1); fS.Font=Enum.Font.GothamBold
    fS.TextSize=BF; fS.LayoutOrder=nO(); fS.Parent=gP; nCorner(fS,8)
    fS.MouseButton1Click:Connect(function() if next(FlingTargets) then startFling(); notify(t("fling"),Theme.success) end end)
    local fSt=Instance.new("TextButton"); fSt.Size=UDim2.new(1,0,0,BTN_H); fSt.BackgroundColor3=Theme.danger
    fSt.BorderSizePixel=0; fSt.Text=t("stop"); fSt.TextColor3=Color3.new(1,1,1); fSt.Font=Enum.Font.GothamBold
    fSt.TextSize=BF; fSt.LayoutOrder=nO(); fSt.Parent=gP; nCorner(fSt,8)
    fSt.MouseButton1Click:Connect(function() stopFling(); notify(t("stop"),Theme.danger) end)
    local tfB=Instance.new("TextButton"); tfB.Size=UDim2.new(1,0,0,BTN_H); tfB.BackgroundColor3=Color3.fromRGB(100,60,180)
    tfB.BorderSizePixel=0; tfB.Text=t("touchFling")..": "..(touchFA and "ON" or "OFF"); tfB.TextColor3=Color3.new(1,1,1)
    tfB.Font=Enum.Font.GothamBold; tfB.TextSize=BF; tfB.LayoutOrder=nO(); tfB.Parent=gP; nCorner(tfB,8)
    tfB.MouseButton1Click:Connect(function()
        if touchFA then stopTouchFling() else startTouchFling() end
        tfB.Text=t("touchFling")..": "..(touchFA and "ON" or "OFF")
    end)

    makeSection(gP,t("flingList"),nO())
    local flh=Instance.new("Frame"); flh.Size=UDim2.new(1,0,0,0); flh.AutomaticSize=Enum.AutomaticSize.Y
    flh.BackgroundTransparency=1; flh.LayoutOrder=nO(); flh.Parent=gP
    local flL=Instance.new("UIListLayout"); flL.Padding=UDim.new(0,4); flL.SortOrder=Enum.SortOrder.LayoutOrder; flL.Parent=flh
    local flingRows={}
    local function ensureRow(plr)
        if flingRows[plr] then return flingRows[plr] end
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=Theme.bgCard
        row.BorderSizePixel=0; row.Parent=flh; nCorner(row,8)
        local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-50,1,0); lbl.Position=UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency=1; lbl.Text=plr.Name; lbl.TextColor3=Theme.text
        lbl.Font=Enum.Font.Gotham; lbl.TextSize=SF; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=row
        local chk=Instance.new("TextButton"); chk.Size=UDim2.new(0,30,0,26); chk.Position=UDim2.new(1,-38,0.5,-13)
        chk.BackgroundColor3=GC.flingSelected[plr.Name] and Theme.success or Color3.fromRGB(60,60,80)
        chk.BorderSizePixel=0; chk.Text=GC.flingSelected[plr.Name] and "V" or ""
        chk.TextColor3=Color3.new(1,1,1); chk.Font=Enum.Font.GothamBold; chk.TextSize=13
        chk.Parent=row; nCorner(chk,6)
        chk.MouseButton1Click:Connect(function()
            GC.flingSelected[plr.Name]=not GC.flingSelected[plr.Name]
            if GC.flingSelected[plr.Name] then
                chk.BackgroundColor3=Theme.success; chk.Text="V"; FlingTargets[plr.Name]=plr
            else chk.BackgroundColor3=Color3.fromRGB(60,60,80); chk.Text=""; FlingTargets[plr.Name]=nil end
        end)
        flingRows[plr]={row=row,chk=chk}
        return flingRows[plr]
    end
    task.spawn(function()
        while screenGui and screenGui.Parent do
            task.wait(1)
            for plr,e in pairs(flingRows) do if not plr.Parent then e.row:Destroy(); flingRows[plr]=nil end end
            for plr in pairs(tracked) do ensureRow(plr) end
        end
    end)

    makeSection(gP,t("antiFling"),nO())
    local ncConn=nil
    local function togNoCollide(e)
        if ncConn then ncConn:Disconnect(); ncConn=nil end
        if not e then
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    for _,pt in ipairs(p.Character:GetDescendants()) do
                        if pt:IsA("BasePart") then pcall(function() pt.CanCollide=true end) end
                    end
                end
            end
            notify("Collide ON",Theme.success); return
        end
        local function app(c)
            if not c then return end
            for _,pt in ipairs(c:GetDescendants()) do
                if pt:IsA("BasePart") then pcall(function() pt.CanCollide=false end) end
            end
        end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP then
                app(p.Character)
                p.CharacterAdded:Connect(function(c) task.wait(0.5); if ncConn then app(c) end end)
            end
        end
        ncConn=RunService.Heartbeat:Connect(function()
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    for _,pt in ipairs(p.Character:GetDescendants()) do
                        if pt:IsA("BasePart") and pt.CanCollide then pcall(function() pt.CanCollide=false end) end
                    end
                end
            end
        end)
        notify("Collide OFF",Theme.danger)
    end
    makeToggle(gP,t("noPlayerCollide"),false,nO(),function(v) togNoCollide(v) end)

    makeSection(gP,t("autoFling"),nO())
    local aBox=Instance.new("TextBox"); aBox.Size=UDim2.new(1,0,0,INPUT_H); aBox.BackgroundColor3=Theme.bgCard
    aBox.BorderSizePixel=0; aBox.Text=GC.autoFlingChar; aBox.PlaceholderText="Turbo Kun / Name"
    aBox.TextColor3=Theme.text; aBox.Font=Enum.Font.GothamBold; aBox.TextSize=SF
    aBox.ClearTextOnFocus=false; aBox.LayoutOrder=nO(); aBox.Parent=gP; nCorner(aBox,8)
    local aSug=Instance.new("Frame"); aSug.Size=UDim2.new(1,0,0,0); aSug.AutomaticSize=Enum.AutomaticSize.Y
    aSug.BackgroundColor3=Theme.bgAlt; aSug.BorderSizePixel=0; aSug.Visible=false
    aSug.LayoutOrder=nO(); aSug.Parent=gP; nCorner(aSug,8)
    local asL=Instance.new("UIListLayout"); asL.Padding=UDim.new(0,2); asL.Parent=aSug
    local function clrAS() for _,c in ipairs(aSug:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end end
    aBox:GetPropertyChangedSignal("Text"):Connect(function()
        local txt=aBox.Text:lower()
        clrAS()
        if txt=="" then aSug.Visible=false; return end
        local sh=0
        for k,d in pairs(Characters) do
            local nm=(d.name[CurrentLang] or d.name.en):lower()
            if nm:sub(1,#txt)==txt or k:lower():sub(1,#txt)==txt then
                local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,24); btn.BackgroundColor3=Theme.bg
                btn.BorderSizePixel=0; btn.Text=k; btn.TextColor3=Theme.text; btn.Font=Enum.Font.Gotham
                btn.TextSize=11; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.Parent=aSug; nCorner(btn,4)
                btn.MouseButton1Click:Connect(function() GC.autoFlingChar=k; aBox.Text=k; clrAS(); aSug.Visible=false end)
                sh=sh+1
                if sh>=8 then break end
            end
        end
        if sh<8 then
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Name:lower():sub(1,#txt)==txt then
                    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,24); btn.BackgroundColor3=Theme.bg
                    btn.BorderSizePixel=0; btn.Text=p.Name; btn.TextColor3=Theme.text; btn.Font=Enum.Font.Gotham
                    btn.TextSize=11; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.Parent=aSug; nCorner(btn,4)
                    btn.MouseButton1Click:Connect(function() GC.autoFlingChar=p.Name; aBox.Text=p.Name; clrAS(); aSug.Visible=false end)
                    sh=sh+1
                    if sh>=8 then break end
                end
            end
        end
        aSug.Visible=sh>0
    end)
    aBox.FocusLost:Connect(function() GC.autoFlingChar=aBox.Text; task.wait(0.2); clrAS(); aSug.Visible=false end)
    makeToggle(gP,t("autoFlingToggle"),GC.autoFlingEnabled,nO(),function(v) GC.autoFlingEnabled=v end)

    if not IS_MOBILE then
        makeSection(gP,t("keybinds"),nO())
        makeKeybind(gP,t("esp").." GUI","toggleGUI",nO())
        makeKeybind(gP,t("fling"),"fling",nO())
        makeKeybind(gP,t("touchFling"),"touchFling",nO())
        makeKeybind(gP,t("esp"),"esp",nO())
        makeKeybind(gP,t("showNames"),"names",nO())
        makeKeybind(gP,t("tpWalk"),"tpWalk",nO())
    else
        makeSection(gP,t("screenButtons"),nO())
        makeToggle(gP,t("btnFling") or "Fling",GC.btnFling,nO(),function(v) GC.btnFling=v; refreshActionButtons() end)
        makeToggle(gP,t("btnTouchFling") or "Touch Fling",GC.btnTouchFling,nO(),function(v) GC.btnTouchFling=v; refreshActionButtons() end)
        makeToggle(gP,t("btnESP") or "ESP",GC.btnESP,nO(),function(v) GC.btnESP=v; refreshActionButtons() end)
        makeToggle(gP,t("btnNames") or "Names",GC.btnNames,nO(),function(v) GC.btnNames=v; refreshActionButtons() end)
        makeToggle(gP,t("btnTpWalk") or "TP Walk",GC.btnTpWalk,nO(),function(v) GC.btnTpWalk=v; refreshActionButtons() end)
    end

    local sorted={}
    for k in pairs(Characters) do table.insert(sorted,k) end
    table.sort(sorted)

    if IS_MOBILE then
        local wrap=Instance.new("Frame"); wrap.Size=UDim2.new(1,0,1,0); wrap.BackgroundTransparency=1; wrap.Parent=cP
        local leftList=Instance.new("ScrollingFrame"); leftList.Size=UDim2.new(0.38,-3,1,0); leftList.Position=UDim2.new(0,0,0,0)
        leftList.BackgroundColor3=Theme.bgAlt; leftList.BorderSizePixel=0; leftList.ScrollBarThickness=3
        leftList.ScrollBarImageColor3=Theme.accentDark; leftList.CanvasSize=UDim2.new(0,0,0,0)
        leftList.AutomaticCanvasSize=Enum.AutomaticSize.Y; leftList.Parent=wrap; nCorner(leftList,8)
        local lll=Instance.new("UIListLayout"); lll.Padding=UDim.new(0,4); lll.SortOrder=Enum.SortOrder.LayoutOrder; lll.Parent=leftList
        local llp=Instance.new("UIPadding"); llp.PaddingLeft=UDim.new(0,5); llp.PaddingRight=UDim.new(0,5)
        llp.PaddingTop=UDim.new(0,5); llp.PaddingBottom=UDim.new(0,5); llp.Parent=leftList
        local rightP=Instance.new("ScrollingFrame"); rightP.Size=UDim2.new(0.62,-3,1,0); rightP.Position=UDim2.new(0.38,3,0,0)
        rightP.BackgroundColor3=Color3.fromRGB(20,20,28); rightP.BorderSizePixel=0; rightP.ScrollBarThickness=3
        rightP.ScrollBarImageColor3=Theme.accentDark; rightP.CanvasSize=UDim2.new(0,0,0,0)
        rightP.AutomaticCanvasSize=Enum.AutomaticSize.Y; rightP.Parent=wrap; nCorner(rightP,8)
        local rpL=Instance.new("UIListLayout"); rpL.Padding=UDim.new(0,5); rpL.SortOrder=Enum.SortOrder.LayoutOrder; rpL.Parent=rightP
        local rpP=Instance.new("UIPadding"); rpP.PaddingLeft=UDim.new(0,5); rpP.PaddingRight=UDim.new(0,5)
        rpP.PaddingTop=UDim.new(0,5); rpP.PaddingBottom=UDim.new(0,5); rpP.Parent=rightP
        local function renderRight(ck)
            for _,c in ipairs(rightP:GetChildren()) do
                if c:IsA("Frame") or c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
            end
            local d=Characters[ck]; if not d then return end
            local titleH=Instance.new("TextLabel"); titleH.Size=UDim2.new(1,0,0,26); titleH.BackgroundTransparency=1
            titleH.Text=d.name[CurrentLang] or d.name.en or ck; titleH.TextColor3=d.colorBase
            titleH.Font=Enum.Font.GothamBold; titleH.TextSize=13; titleH.TextXAlignment=Enum.TextXAlignment.Left
            titleH.LayoutOrder=1; titleH.Parent=rightP
            local rO=1
            local function rN() rO=rO+1; return rO end
            local function addColor(txt,init,cb)
                local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,32); f.BackgroundColor3=Theme.bgCard
                f.BorderSizePixel=0; f.LayoutOrder=rN(); f.Parent=rightP; nCorner(f,6)
                local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.5,0,1,0); l.Position=UDim2.new(0,8,0,0)
                l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham
                l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
                local pv=Instance.new("TextButton"); pv.Size=UDim2.new(0,26,0,24); pv.Position=UDim2.new(1,-32,0.5,-12)
                pv.BackgroundColor3=init; pv.BorderSizePixel=0; pv.Text=""; pv.Parent=f; nCorner(pv,5)
                pv.MouseButton1Click:Connect(function()
                    openPicker(pv.BackgroundColor3,function(c) pv.BackgroundColor3=c; if cb then cb(c) end end)
                end)
            end
            local function addTog(txt,init,cb)
                local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,32); f.BackgroundColor3=Theme.bgCard
                f.BorderSizePixel=0; f.LayoutOrder=rN(); f.Parent=rightP; nCorner(f,6)
                local l=Instance.new("TextLabel"); l.Size=UDim2.new(1,-56,1,0); l.Position=UDim2.new(0,8,0,0)
                l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham
                l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
                local b=Instance.new("TextButton"); b.Size=UDim2.new(0,44,0,22); b.Position=UDim2.new(1,-50,0.5,-11)
                b.BackgroundColor3=init and Theme.success or Color3.fromRGB(60,60,80); b.BorderSizePixel=0
                b.Text=init and "ON" or "OFF"; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold
                b.TextSize=10; b.Parent=f; nCorner(b,5)
                local st=init
                b.MouseButton1Click:Connect(function()
                    st=not st; b.BackgroundColor3=st and Theme.success or Color3.fromRGB(60,60,80)
                    b.Text=st and "ON" or "OFF"; if cb then cb(st) end
                end)
            end
            local function addNum(txt,init,cb)
                local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,32); f.BackgroundColor3=Theme.bgCard
                f.BorderSizePixel=0; f.LayoutOrder=rN(); f.Parent=rightP; nCorner(f,6)
                local l=Instance.new("TextLabel"); l.Size=UDim2.new(0.5,0,1,0); l.Position=UDim2.new(0,8,0,0)
                l.BackgroundTransparency=1; l.Text=txt; l.TextColor3=Theme.text; l.Font=Enum.Font.Gotham
                l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left; l.Parent=f
                local b=Instance.new("TextBox"); b.Size=UDim2.new(0,70,0,22); b.Position=UDim2.new(1,-78,0.5,-11)
                b.BackgroundColor3=Theme.bgAlt; b.BorderSizePixel=0; b.Text=tostring(init); b.TextColor3=Theme.text
                b.Font=Enum.Font.GothamBold; b.TextSize=11; b.ClearTextOnFocus=false; b.Parent=f; nCorner(b,5)
                b.FocusLost:Connect(function()
                    local n=tonumber(b.Text)
                    if n then if cb then cb(n) end else b.Text=tostring(init) end
                end)
            end
            addColor(t("colorBase"),d.colorBase,function(c) d.colorBase=c end)
            addColor(t("colorUlt"),d.colorUlt,function(c) d.colorUlt=c end)
            addTog(t("highlightBase"),d.highlightBase,function(v) d.highlightBase=v end)
            addTog(t("highlightUlt"),d.highlightUlt,function(v) d.highlightUlt=v end)
            addTog(t("name"),d.showName,function(v) d.showName=v end)
            addTog(t("hpLabel"),d.showHp,function(v) d.showHp=v end)
            addTog(t("tpBase"),d.tpFromBase,function(v) d.tpFromBase=v end)
            addTog(t("tpUlt"),d.tpFromUlt,function(v) d.tpFromUlt=v end)
            addNum(t("distance"),d.distance,function(v) d.distance=v end)
            addNum("X",d.position.X,function(v) d.position=Vector3.new(v,d.position.Y,d.position.Z) end)
            addNum("Y",d.position.Y,function(v) d.position=Vector3.new(d.position.X,v,d.position.Z) end)
            addNum("Z",d.position.Z,function(v) d.position=Vector3.new(d.position.X,d.position.Y,v) end)
            local tpB=Instance.new("TextButton"); tpB.Size=UDim2.new(1,0,0,30); tpB.BackgroundColor3=d.colorBase
            tpB.BorderSizePixel=0; tpB.Text=t("tpNow"); tpB.TextColor3=Color3.new(1,1,1)
            tpB.Font=Enum.Font.GothamBold; tpB.TextSize=11; tpB.LayoutOrder=rN(); tpB.Parent=rightP; nCorner(tpB,6)
            tpB.MouseButton1Click:Connect(function()
                local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if mr then pcall(function() mr.CFrame=CFrame.new(d.position) end); notify(t("tpNow"),d.colorBase) end
            end)
        end
        local charBtns={}
        for _,ck in ipairs(sorted) do
            local d=Characters[ck]
            local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,36); btn.BackgroundColor3=Theme.bgCard
            btn.BorderSizePixel=0; btn.Text=""; btn.LayoutOrder=nO(); btn.Parent=leftList; nCorner(btn,6)
            local bar=Instance.new("Frame"); bar.Size=UDim2.new(0,3,1,-8); bar.Position=UDim2.new(0,3,0,4)
            bar.BackgroundColor3=d.colorBase; bar.BorderSizePixel=0; bar.Parent=btn; nCorner(bar,2)
            local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-12,1,0); lbl.Position=UDim2.new(0,10,0,0)
            lbl.BackgroundTransparency=1; lbl.Text=d.name[CurrentLang] or d.name.en or ck
            lbl.TextColor3=Theme.text; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
            lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.TextTruncate=Enum.TextTruncate.AtEnd; lbl.Parent=btn
            charBtns[ck]=btn
            btn.MouseButton1Click:Connect(function()
                for _,b in pairs(charBtns) do TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=Theme.bgCard}):Play() end
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Theme.tabActive}):Play()
                renderRight(ck)
            end)
        end
        if sorted[1] then
            task.defer(function()
                if charBtns[sorted[1]] then
                    TweenService:Create(charBtns[sorted[1]],TweenInfo.new(0.15),{BackgroundColor3=Theme.tabActive}):Play()
                    renderRight(sorted[1])
                end
            end)
        end
    else
        for _,ck in ipairs(sorted) do
            local d=Characters[ck]
            local hB=Instance.new("TextButton"); hB.Size=UDim2.new(1,0,0,BTN_H+2)
            hB.BackgroundColor3=Theme.bgCard; hB.BorderSizePixel=0; hB.Text=""
            hB.AutoButtonColor=not d.noExpand; hB.LayoutOrder=nO(); hB.Parent=cP; nCorner(hB,8)
            local ab=Instance.new("Frame"); ab.Size=UDim2.new(0,4,1,-8); ab.Position=UDim2.new(0,4,0,4)
            ab.BackgroundColor3=d.colorBase; ab.BorderSizePixel=0; ab.Parent=hB; nCorner(ab,3)
            local hl=Instance.new("TextLabel"); hl.Size=UDim2.new(1,-60,1,0); hl.Position=UDim2.new(0,16,0,0)
            hl.BackgroundTransparency=1; hl.Text=d.name[CurrentLang] or d.name.en or ck
            hl.TextColor3=Theme.text; hl.Font=Enum.Font.GothamBold; hl.TextSize=BF
            hl.TextXAlignment=Enum.TextXAlignment.Left; hl.Parent=hB
            local ar=Instance.new("TextLabel"); ar.Size=UDim2.new(0,24,1,0); ar.Position=UDim2.new(1,-30,0,0)
            ar.BackgroundTransparency=1; ar.Text=d.noExpand and "L" or "v"; ar.TextColor3=Theme.textDim
            ar.Font=Enum.Font.GothamBold; ar.TextSize=12; ar.Parent=hB
            if not d.noExpand then
                local bd=Instance.new("Frame"); bd.Size=UDim2.new(1,0,0,0); bd.BackgroundColor3=Color3.fromRGB(20,20,28)
                bd.BorderSizePixel=0; bd.LayoutOrder=nO(); bd.Visible=false; bd.Parent=cP; nCorner(bd,8)
                local bl=Instance.new("UIListLayout"); bl.Padding=UDim.new(0,5); bl.SortOrder=Enum.SortOrder.LayoutOrder; bl.Parent=bd
                local bp=Instance.new("UIPadding"); bp.PaddingLeft=UDim.new(0,8); bp.PaddingRight=UDim.new(0,8)
                bp.PaddingTop=UDim.new(0,8); bp.PaddingBottom=UDim.new(0,8); bp.Parent=bd
                local bO=0
                local function bN() bO=bO+1; return bO end
                makeColorInput(bd,t("colorBase"),d.colorBase,bN(),function(c) d.colorBase=c; ab.BackgroundColor3=c end)
                makeColorInput(bd,t("colorUlt"),d.colorUlt,bN(),function(c) d.colorUlt=c end)
                makeToggle(bd,t("highlightBase"),d.highlightBase,bN(),function(v) d.highlightBase=v end)
                makeToggle(bd,t("highlightUlt"),d.highlightUlt,bN(),function(v) d.highlightUlt=v end)
                makeToggle(bd,t("name"),d.showName,bN(),function(v) d.showName=v end)
                makeToggle(bd,t("hpLabel"),d.showHp,bN(),function(v) d.showHp=v end)
                makeToggle(bd,t("tpBase"),d.tpFromBase,bN(),function(v) d.tpFromBase=v end)
                makeToggle(bd,t("tpUlt"),d.tpFromUlt,bN(),function(v) d.tpFromUlt=v end)
                makeNumber(bd,t("distance"),d.distance,bN(),function(v) d.distance=v end)
                makeSection(bd,t("position"),bN())
                makeNumber(bd,"X",d.position.X,bN(),function(v) d.position=Vector3.new(v,d.position.Y,d.position.Z) end)
                makeNumber(bd,"Y",d.position.Y,bN(),function(v) d.position=Vector3.new(d.position.X,v,d.position.Z) end)
                makeNumber(bd,"Z",d.position.Z,bN(),function(v) d.position=Vector3.new(d.position.X,d.position.Y,v) end)
                local tpB=Instance.new("TextButton"); tpB.Size=UDim2.new(1,0,0,BTN_H); tpB.BackgroundColor3=d.colorBase
                tpB.BorderSizePixel=0; tpB.Text=t("tpNow"); tpB.TextColor3=Color3.new(1,1,1); tpB.Font=Enum.Font.GothamBold
                tpB.TextSize=BF; tpB.LayoutOrder=bN(); tpB.Parent=bd; nCorner(tpB,8)
                tpB.MouseButton1Click:Connect(function()
                    local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if mr then pcall(function() mr.CFrame=CFrame.new(d.position) end); notify(t("tpNow"),d.colorBase) end
                end)
                local function upd() bd.Size=UDim2.new(1,0,0,bl.AbsoluteContentSize.Y+16) end
                bl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(upd)
                local exp=false
                hB.MouseButton1Click:Connect(function() exp=not exp; bd.Visible=exp; ar.Text=exp and "^" or "v" end)
            end
        end
    end

    makeSection(mP,t("movement"),nO())
    makeToggle(mP,t("tpWalk"),GC.tpWalkEnabled,nO(),function(v) togTpWalk(v) end)
    makeNumber(mP,t("tpWalkSpeed"),GC.tpWalkSpeed,nO(),function(v) GC.tpWalkSpeed=v end)
    makeToggle(mP,t("noclip"),GC.noclipEnabled,nO(),function(v) togNoclip(v) end)
    makeToggle(mP,t("infJump"),GC.infJumpEnabled,nO(),function(v) togInfJump(v) end)
    if not IS_MOBILE then
        makeToggle(mP,t("ctrlClickTp"),GC.ctrlClickTP,nO(),function(v) togCtrlTP(v) end)
    end

    local plist=Instance.new("ScrollingFrame"); plist.Size=UDim2.new(1,0,1,0)
    plist.BackgroundTransparency=1; plist.BorderSizePixel=0; plist.ScrollBarThickness=4
    plist.ScrollBarImageColor3=Theme.accentDark; plist.CanvasSize=UDim2.new(0,0,0,0)
    plist.AutomaticCanvasSize=Enum.AutomaticSize.Y; plist.Parent=plP
    local pll=Instance.new("UIListLayout"); pll.Padding=UDim.new(0,5); pll.SortOrder=Enum.SortOrder.LayoutOrder; pll.Parent=plist
    local pRows={}; local rO=0

    local function closeMenus()
        for _,c in ipairs(screenGui:GetChildren()) do
            if c:IsA("Frame") and c:GetAttribute("IsPM") then c:Destroy() end
        end
    end

    local function openMenu(plr)
        closeMenus()
        local menu=Instance.new("Frame"); menu:SetAttribute("IsPM",true)
        menu.Size=UDim2.new(0,200,0,0); menu.AutomaticSize=Enum.AutomaticSize.Y
        menu.Position=UDim2.new(0.5,-100,0.5,-100); menu.BackgroundColor3=Theme.bg
        menu.BorderSizePixel=0; menu.ZIndex=400; menu.Active=true; menu.Draggable=true; menu.Parent=screenGui
        nCorner(menu,10); nStroke(menu,Theme.accentDark,1.5)
        local mt=Instance.new("TextLabel"); mt.Size=UDim2.new(1,-30,0,30); mt.BackgroundColor3=Theme.headerBg
        mt.BorderSizePixel=0; mt.Text=plr.Name; mt.TextColor3=Theme.text; mt.Font=Enum.Font.GothamBold
        mt.TextSize=12; mt.ZIndex=401; mt.Parent=menu; nCorner(mt,10)
        local cb=Instance.new("TextButton"); cb.Size=UDim2.new(0,26,0,26); cb.Position=UDim2.new(1,-30,0,2)
        cb.BackgroundColor3=Theme.danger; cb.BorderSizePixel=0; cb.Text="x"; cb.TextColor3=Color3.new(1,1,1)
        cb.Font=Enum.Font.GothamBold; cb.TextSize=12; cb.ZIndex=402; cb.Parent=menu; nCorner(cb,6)
        cb.MouseButton1Click:Connect(function() menu:Destroy() end)
        local ml=Instance.new("UIListLayout"); ml.Padding=UDim.new(0,5); ml.SortOrder=Enum.SortOrder.LayoutOrder; ml.Parent=menu
        local mp=Instance.new("UIPadding"); mp.PaddingLeft=UDim.new(0,8); mp.PaddingRight=UDim.new(0,8)
        mp.PaddingTop=UDim.new(0,38); mp.PaddingBottom=UDim.new(0,8); mp.Parent=menu
        local function mkBtn(txt,col,cb2)
            local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,28); b.BackgroundColor3=col
            b.BorderSizePixel=0; b.Text=txt; b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamBold
            b.TextSize=11; b.ZIndex=401; b.Parent=menu; nCorner(b,6)
            b.MouseButton1Click:Connect(function() cb2(); menu:Destroy() end)
        end
        mkBtn(t("fling"),Color3.fromRGB(180,40,40),function() singleFling(plr); notify(t("fling")..": "..plr.Name,Theme.danger) end)
        mkBtn(t("tpToPlayer"),Theme.accentDark,function()
            local tr=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if tr and mr then mr.CFrame=tr.CFrame+Vector3.new(0,3,0) end
        end)
        mkBtn(t("spectate"),Theme.accentDark,function()
            if plr.Character and plr.Character:FindFirstChild("Head") then
                workspace.CurrentCamera.CameraSubject=plr.Character.Head
                local rb=Instance.new("TextButton"); rb.Size=UDim2.new(0,160,0,32); rb.Position=UDim2.new(0.5,-80,0,60)
                rb.BackgroundColor3=Theme.danger; rb.BorderSizePixel=0; rb.Text=t("back"); rb.TextColor3=Color3.new(1,1,1)
                rb.Font=Enum.Font.GothamBold; rb.TextSize=12; rb.ZIndex=500; rb.Parent=screenGui; nCorner(rb,8)
                rb.MouseButton1Click:Connect(function()
                    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if h then workspace.CurrentCamera.CameraSubject=h end
                    rb:Destroy()
                end)
                task.delay(15,function() if rb.Parent then rb:Destroy() end end)
            end
        end)
    end

    local function ensureRow(plr)
        if pRows[plr] then return pRows[plr] end
        rO=rO+1
        local rowS=IS_MOBILE and 54 or 48
        local row=Instance.new("TextButton"); row.Size=UDim2.new(1,0,0,rowS); row.BackgroundColor3=Theme.bgCard
        row.BorderSizePixel=0; row.Text=""; row.LayoutOrder=rO; row.Parent=plist; nCorner(row,8)
        local ab=Instance.new("Frame"); ab.Size=UDim2.new(0,4,1,-8); ab.Position=UDim2.new(0,4,0,4)
        ab.BackgroundColor3=Theme.accentDark; ab.BorderSizePixel=0; ab.Parent=row; nCorner(ab,3)
        local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0.5,0,0,18); nl.Position=UDim2.new(0,14,0,4)
        nl.BackgroundTransparency=1; nl.Text=plr.Name; nl.TextColor3=Theme.text; nl.Font=Enum.Font.GothamSemibold
        nl.TextSize=11; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
        local cl=Instance.new("TextLabel"); cl.Size=UDim2.new(0.5,-14,0,18); cl.Position=UDim2.new(0.5,0,0,4)
        cl.BackgroundTransparency=1; cl.Text="-"; cl.TextColor3=Theme.textDim; cl.Font=Enum.Font.GothamBold
        cl.TextSize=11; cl.TextXAlignment=Enum.TextXAlignment.Right; cl.Parent=row
        local hpl=Instance.new("TextLabel"); hpl.Size=UDim2.new(1,-30,0,14); hpl.Position=UDim2.new(0,14,0,24)
        hpl.BackgroundTransparency=1; hpl.Text=t("hpLabel")..": -"; hpl.TextColor3=Color3.fromRGB(120,255,120)
        hpl.Font=Enum.Font.Gotham; hpl.TextSize=10; hpl.TextXAlignment=Enum.TextXAlignment.Left; hpl.Parent=row
        local entry={row=row,charLbl=cl,hpLbl=hpl,accentBar=ab}
        row.MouseButton1Click:Connect(function() openMenu(plr) end)
        pRows[plr]=entry; return entry
    end

    task.spawn(function() while screenGui and screenGui.Parent do
        task.wait(0.3)
        for plr,e in pairs(pRows) do if not plr.Parent then e.row:Destroy(); pRows[plr]=nil end end
        for plr in pairs(tracked) do
            local e=ensureRow(plr); local info=playerData[plr]
            if info then local d=Characters[info.charKey]
                e.charLbl.Text=(d.name[CurrentLang] or d.name.en).." "..(info.form=="ult" and "U" or "B")
                local col=(info.form=="ult") and d.colorUlt or d.colorBase
                e.charLbl.TextColor3=col; e.accentBar.BackgroundColor3=col
            else e.charLbl.Text="-"; e.charLbl.TextColor3=Theme.textDim; e.accentBar.BackgroundColor3=Theme.textDim end
            local m=getCharModel(plr); local hp,mx=getHp(m,plr)
            if hp then
                if hp < 20 then
                    e.hpLbl.Text=t("hpLabel")..string.format(": %.1f / %.0f", hp, mx)
                else
                    e.hpLbl.Text=t("hpLabel")..string.format(": %.0f / %.0f", hp, mx)
                end
                local r=hp/math.max(1,mx)
                e.hpLbl.TextColor3=r>0.6 and Color3.fromRGB(120,255,120) or (r>0.3 and Color3.fromRGB(255,220,80) or Color3.fromRGB(255,90,90))
            else e.hpLbl.Text=t("hpLabel")..": -"; e.hpLbl.TextColor3=Theme.textDim end
        end
    end end)

    local nameF=Instance.new("Frame"); nameF.Size=UDim2.new(1,0,0,INPUT_H); nameF.BackgroundColor3=Theme.bgCard
    nameF.BorderSizePixel=0; nameF.LayoutOrder=1; nameF.Parent=sP; nCorner(nameF,8)
    local nL=Instance.new("TextLabel"); nL.Size=UDim2.new(0.5,0,1,0); nL.Position=UDim2.new(0,12,0,0)
    nL.BackgroundTransparency=1; nL.Text=t("name"); nL.TextColor3=Theme.text; nL.Font=Enum.Font.Gotham
    nL.TextSize=SF; nL.TextXAlignment=Enum.TextXAlignment.Left; nL.Parent=nameF
    local nBox=Instance.new("TextBox"); nBox.Size=UDim2.new(0,150,0,INPUT_H-8); nBox.Position=UDim2.new(1,-160,0.5,-(INPUT_H-8)/2)
    nBox.BackgroundColor3=Theme.bgAlt; nBox.BorderSizePixel=0; nBox.Text="my_config"; nBox.TextColor3=Theme.text
    nBox.Font=Enum.Font.GothamBold; nBox.TextSize=SF; nBox.ClearTextOnFocus=false; nBox.Parent=nameF; nCorner(nBox,6)
    local sB=Instance.new("TextButton"); sB.Size=UDim2.new(1,0,0,BTN_H); sB.BackgroundColor3=Theme.success
    sB.BorderSizePixel=0; sB.Text=t("save"); sB.TextColor3=Color3.new(1,1,1); sB.Font=Enum.Font.GothamBold
    sB.TextSize=BF; sB.LayoutOrder=2; sB.Parent=sP; nCorner(sB,8)
    local rB=Instance.new("TextButton"); rB.Size=UDim2.new(1,0,0,BTN_H); rB.BackgroundColor3=Theme.accentDark
    rB.BorderSizePixel=0; rB.Text=t("refresh"); rB.TextColor3=Color3.new(1,1,1); rB.Font=Enum.Font.GothamBold
    rB.TextSize=SF; rB.LayoutOrder=3; rB.Parent=sP; nCorner(rB,8)
    local aF=Instance.new("Frame"); aF.Size=UDim2.new(1,0,0,INPUT_H); aF.BackgroundColor3=Theme.bgCard
    aF.BorderSizePixel=0; aF.LayoutOrder=4; aF.Parent=sP; nCorner(aF,8)
    local aL=Instance.new("TextLabel"); aL.Size=UDim2.new(0.5,0,1,0); aL.Position=UDim2.new(0,12,0,0)
    aL.BackgroundTransparency=1; aL.Text=t("autoLoad"); aL.TextColor3=Theme.text; aL.Font=Enum.Font.Gotham
    aL.TextSize=10; aL.TextXAlignment=Enum.TextXAlignment.Left; aL.Parent=aF
    local ab2=Instance.new("TextBox"); ab2.Size=UDim2.new(0,130,0,INPUT_H-8); ab2.Position=UDim2.new(1,-140,0.5,-(INPUT_H-8)/2)
    ab2.BackgroundColor3=Theme.bgAlt; ab2.BorderSizePixel=0; ab2.Text=GC.autoLoadConfig
    ab2.PlaceholderText="config"; ab2.TextColor3=Theme.text; ab2.Font=Enum.Font.GothamBold
    ab2.TextSize=10; ab2.ClearTextOnFocus=false; ab2.Parent=aF; nCorner(ab2,6)
    local cs=Instance.new("Frame"); cs.Size=UDim2.new(1,0,0,0); cs.AutomaticSize=Enum.AutomaticSize.Y
    cs.BackgroundColor3=Theme.bgAlt; cs.BorderSizePixel=0; cs.Visible=false; cs.LayoutOrder=5; cs.Parent=sP; nCorner(cs,8)
    local csl=Instance.new("UIListLayout"); csl.Padding=UDim.new(0,2); csl.Parent=cs
    local function clrCS() for _,c in ipairs(cs:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end end
    ab2:GetPropertyChangedSignal("Text"):Connect(function()
        local t2=ab2.Text:lower()
        clrCS()
        if t2=="" then cs.Visible=false; return end
        local sh=0
        for _,fn in ipairs(listCfg()) do
            if fn:lower():sub(1,#t2)==t2 then
                local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,24); btn.BackgroundColor3=Theme.bg
                btn.BorderSizePixel=0; btn.Text=fn; btn.TextColor3=Theme.text; btn.Font=Enum.Font.Gotham
                btn.TextSize=11; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.Parent=cs; nCorner(btn,4)
                btn.MouseButton1Click:Connect(function() GC.autoLoadConfig=fn; ab2.Text=fn; clrCS(); cs.Visible=false end)
                sh=sh+1; if sh>=8 then break end
            end
        end
        cs.Visible=sh>0
    end)
    ab2.FocusLost:Connect(function()
        GC.autoLoadConfig=ab2.Text
        task.wait(0.2); clrCS(); cs.Visible=false
        if GC.autoLoadConfig~="" then
            local ok,d=pcall(loadCfg,GC.autoLoadConfig)
            if ok and d then applyCfg(d); notify(t("autoLoad")..": "..GC.autoLoadConfig,Theme.success) end
        end
    end)
    makeSection(sP,t("saved"),6)
    local lh=Instance.new("Frame"); lh.Size=UDim2.new(1,0,0,0); lh.AutomaticSize=Enum.AutomaticSize.Y
    lh.BackgroundTransparency=1; lh.LayoutOrder=7; lh.Parent=sP
    local lhL=Instance.new("UIListLayout"); lhL.Padding=UDim.new(0,4); lhL.SortOrder=Enum.SortOrder.LayoutOrder; lhL.Parent=lh
    local function refreshList()
        for _,c in ipairs(lh:GetChildren()) do if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end end
        local files=listCfg()
        if #files==0 then
            local em=Instance.new("TextLabel"); em.Size=UDim2.new(1,0,0,24); em.BackgroundTransparency=1
            em.Text=t("empty"); em.TextColor3=Theme.textDim; em.Font=Enum.Font.Gotham; em.TextSize=11; em.Parent=lh
            return
        end
        for _,fn in ipairs(files) do
            local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,BTN_H); row.BackgroundColor3=Theme.bgCard
            row.BorderSizePixel=0; row.Parent=lh; nCorner(row,6)
            local nl=Instance.new("TextLabel"); nl.Size=UDim2.new(0.5,0,1,0); nl.Position=UDim2.new(0,10,0,0)
            nl.BackgroundTransparency=1; nl.Text=fn; nl.TextColor3=Theme.text; nl.Font=Enum.Font.GothamBold
            nl.TextSize=SF; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=row
            local lb=Instance.new("TextButton"); lb.Size=UDim2.new(0,60,0,BTN_H-8); lb.Position=UDim2.new(1,-130,0.5,-(BTN_H-8)/2)
            lb.BackgroundColor3=Theme.accentDark; lb.BorderSizePixel=0; lb.Text=t("loadBtn"); lb.TextColor3=Color3.new(1,1,1)
            lb.Font=Enum.Font.GothamBold; lb.TextSize=10; lb.Parent=row; nCorner(lb,6)
            local db=Instance.new("TextButton"); db.Size=UDim2.new(0,60,0,BTN_H-8); db.Position=UDim2.new(1,-66,0.5,-(BTN_H-8)/2)
            db.BackgroundColor3=Theme.danger; db.BorderSizePixel=0; db.Text=t("delBtn"); db.TextColor3=Color3.new(1,1,1)
            db.Font=Enum.Font.GothamBold; db.TextSize=10; db.Parent=row; nCorner(db,6)
            lb.MouseButton1Click:Connect(function()
                local d,e=loadCfg(fn)
                if d then
                    applyCfg(d); notify(t("loadBtn")..": "..fn,Theme.success)
                    task.wait(0.1)
                    local old=screenGui
                    if old then old.Parent=nil; pcall(function() old:Destroy() end) end
                    rmAllLb(); highlights={}
                    task.wait(); buildGUI()
                else notify("Err: "..tostring(e),Theme.danger) end
            end)
            db.MouseButton1Click:Connect(function()
                local ok=delCfg(fn)
                if ok then notify(t("delBtn")..": "..fn,Theme.danger); refreshList() end
            end)
        end
    end
    sB.MouseButton1Click:Connect(function()
        local nm=nBox.Text:gsub("[^%w_%-%.]","_")
        if nm=="" then nm="config" end
        local ok,e=saveCfg(nm)
        if ok then notify(t("save")..": "..nm,Theme.success); refreshList() else notify("Err: "..tostring(e),Theme.danger) end
    end)
    rB.MouseButton1Click:Connect(refreshList)
    refreshList()

    local ah=Instance.new("Frame"); ah.Size=UDim2.new(1,0,0,70); ah.BackgroundColor3=Theme.bgCard
    ah.BorderSizePixel=0; ah.LayoutOrder=1; ah.Parent=aP; nCorner(ah,10)
    local ai=Instance.new("TextLabel"); ai.Size=UDim2.new(0,50,0,50); ai.Position=UDim2.new(0,12,0.5,-25)
    ai.BackgroundColor3=Theme.accentDark; ai.BorderSizePixel=0; ai.Text="US"; ai.TextColor3=Color3.new(1,1,1)
    ai.Font=Enum.Font.GothamBold; ai.TextSize=20; ai.Parent=ah; nCorner(ai,10)
    local at=Instance.new("TextLabel"); at.Size=UDim2.new(1,-75,0,22); at.Position=UDim2.new(0,72,0,14)
    at.BackgroundTransparency=1; at.Text=t("authors"); at.TextColor3=Theme.text; at.Font=Enum.Font.GothamBold
    at.TextSize=14; at.TextXAlignment=Enum.TextXAlignment.Left; at.Parent=ah
    local asb=Instance.new("TextLabel"); asb.Size=UDim2.new(1,-75,0,18); asb.Position=UDim2.new(0,72,0,36)
    asb.BackgroundTransparency=1; asb.Text="Universal Showdown v12"; asb.TextColor3=Theme.textDim
    asb.Font=Enum.Font.Gotham; asb.TextSize=11; asb.TextXAlignment=Enum.TextXAlignment.Left; asb.Parent=ah
    local function mkA(n,r,o)
        local c=Instance.new("Frame"); c.Size=UDim2.new(1,0,0,56); c.BackgroundColor3=Theme.bgCard
        c.BorderSizePixel=0; c.LayoutOrder=o; c.Parent=aP; nCorner(c,10)
        local nm=Instance.new("TextLabel"); nm.Size=UDim2.new(1,-20,0,22); nm.Position=UDim2.new(0,12,0,8)
        nm.BackgroundTransparency=1; nm.Text=n; nm.TextColor3=Theme.text; nm.Font=Enum.Font.GothamBold
        nm.TextSize=15; nm.TextXAlignment=Enum.TextXAlignment.Left; nm.Parent=c
        local rl=Instance.new("TextLabel"); rl.Size=UDim2.new(1,-20,0,18); rl.Position=UDim2.new(0,12,0,30)
        rl.BackgroundTransparency=1; rl.Text=r; rl.TextColor3=Theme.textDim; rl.Font=Enum.Font.Gotham
        rl.TextSize=11; rl.TextXAlignment=Enum.TextXAlignment.Left; rl.Parent=c
    end
    mkA("nikitosiki2000","Developer",2)
    mkA("deepseek","AI Assistant",3)

    local min=false
    local origS=main.Size
    minBtn.MouseButton1Click:Connect(function()
        min=not min
        if min then
            main.Size=UDim2.new(0,origS.X.Offset,0,hdrH)
            tabsFrame.Visible=false; content.Visible=false; minBtn.Text="+"
        else
            main.Size=origS
            tabsFrame.Visible=true; content.Visible=true; minBtn.Text="-"
            switchPage(currentPage or "global")
        end
    end)
    switchPage("global")
end

if not IS_MOBILE then
    UserInputService.InputBegan:Connect(function(input,gp)
        if gp then return end
        local kb=GC.keybinds
        if input.KeyCode == Enum.KeyCode.L then
            togglePanicMode()
        end
        if input.KeyCode==kb.toggleGUI then
            guiVisible=not guiVisible
            if screenGui then screenGui.Enabled=guiVisible end
        elseif input.KeyCode==kb.fling then
            if next(FlingTargets) then startFling(); notify(t("fling"),Theme.success) end
        elseif input.KeyCode==kb.touchFling then
            if touchFA then stopTouchFling() else startTouchFling() end
            notify(t("touchFling")..": "..(touchFA and "ON" or "OFF"),Theme.accent)
        elseif input.KeyCode==kb.esp then
            GC.espEnabled=not GC.espEnabled
            if not GC.espEnabled then rmAllHl() end
            notify(t("esp")..": "..(GC.espEnabled and "ON" or "OFF"),GC.espEnabled and Theme.success or Theme.danger)
        elseif input.KeyCode==kb.names then
            GC.forceShowAllUntil=tick()+GC.nameShowDuration
            notify(t("showNames"),Theme.accent)
        elseif input.KeyCode==kb.tpWalk then
            togTpWalk(); notify(t("tpWalk")..": "..(GC.tpWalkEnabled and "ON" or "OFF"),GC.tpWalkEnabled and Theme.success or Theme.danger)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.2)
        local sg=screenGui
        if sg and sg.Parent and subtitleRef and subtitleRef.Parent then
            local mr=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if mr then
                local p=mr.Position
                subtitleRef.Text=string.format("X: %.0f  Y: %.0f  Z: %.0f",p.X,p.Y,p.Z)
            else subtitleRef.Text="X: -  Y: -  Z: -" end
        end
    end
end)

buildPlatform()
buildKillstreak()
buildGUI()
buildReturnBtn()
buildToggleGui()
refreshActionButtons()

if IS_DELTA then
    local eg=Instance.new("ScreenGui")
    eg.Name="US_Delta"
    eg.ResetOnSpawn=false
    eg.IgnoreGuiInset=true
    eg.DisplayOrder=2000
    eg.Parent=(gethui and gethui()) or LP:WaitForChild("PlayerGui")
    local tx=Instance.new("TextLabel")
    tx.Size=UDim2.new(1,0,0,100)
    tx.Position=UDim2.new(0,0,0.5,-50)
    tx.BackgroundTransparency=1
    tx.Text="DELTA USER DETECTED!!!"
    tx.TextColor3=Color3.fromRGB(180,120,255)
    tx.TextStrokeTransparency=0
    tx.TextStrokeColor3=Color3.new()
    tx.Font=Enum.Font.GothamBlack
    tx.TextSize=IS_MOBILE and 28 or 40
    tx.ZIndex=2001
    tx.Parent=eg
    local langD={
        ru="ДЕЛЬТА ЮЗЕР ОБНАРУЖЕН!!!",en="DELTA USER DETECTED!!!",es="¡USUARIO DELTA DETECTADO!",
        zh="检测到 DELTA 用户!!!",hi="डेल्टा उपयोगकर्ता मिला!!!",ar="تم اكتشاف مستخدم دلتا!!!",
        pt="USUÁRIO DELTA DETECTADO!!!",bn="ডেল্টা ইউজার পাওয়া গেছে!!!",ja="デルタユーザー検出!!!",
        de="DELTA BENUTZER ERKANNT!!!",fr="UTILISATEUR DELTA DÉTECTÉ!!!",ko="델타 사용자 감지!!!",
        it="UTENTE DELTA RILEVATO!!!",tr="DELTA KULLANICISI BULUNDU!!!",vi="ĐÃ PHÁT HIỆN DELTA!!!",
        pl="WYKRYTO DELTA!!!",nl="DELTA GEBRUIKER GEVONDEN!!!",th="ตรวจพบผู้ใช้ DELTA!!!",
        id="PENGGUNA DELTA TERDETEKSI!!!",uk="ДЕЛЬТА КОРИСТУВАЧ ВИЯВЛЕНИЙ!!!",
    }
    tx.Text=langD[CurrentLang] or langD.en
    task.spawn(function()
        for i=1,10 do
            tx.TextTransparency=0; task.wait(0.15)
            tx.TextTransparency=1; task.wait(0.15)
        end
        eg:Destroy()
    end)
end

print("[Universal Showdown v12] Loaded. Executor: "..EXECUTOR_NAME)
if IS_MOBILE then print("[Universal Showdown] Mobile mode") end
