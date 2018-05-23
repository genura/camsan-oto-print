unit UFMainnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sEdit, Spin, Menus, Buttons, ComCtrls;

type
  TFMain = class(TForm)
    EtiketAdi: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    komutAraligi: TSpinEdit;
    komutSayisi: TSpinEdit;
    MainMenu1: TMainMenu;
    D1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Y1: TMenuItem;
    H1: TMenuItem;
    btnKomutGonder: TBitBtn;
    btnEtiketDosyaAc: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    durumLabel: TLabel;
    etiketSayisi: TLabel;
    islemDurumu: TProgressBar;
    StatusBar1: TStatusBar;
    DialogEtiket: TOpenDialog;
    hata: TLabel;
    zaman: TTimer;
    procedure H1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure btnEtiketDosyaAcClick(Sender: TObject);
    procedure btnKomutGonderClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure zamanTimer(Sender: TObject);
  private

    { Private declarations }
    HotKeyID: Integer;
    HotKeyIDFunctionA, HotKeyIDFunctionB: Integer;
    HotKeyIDPrintKey: Integer;

    //
    proHandle: hwnd;
    proBaslik:String;

    //zaman sayacý
    zs:integer;

    procedure hataDurumu(drm:boolean);
        procedure WMHotKey(var Msg: TWMHotKey);  message WM_HOTKEY;
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UFhakkinda, sndkey32tr;

{$R *.dfm}

procedure TFMain.btnEtiketDosyaAcClick(Sender: TObject);
begin
//etiket dosyasý için dialogu aç
DialogEtiket.Execute();
EtiketAdi.Text:= ExtractFileName (DialogEtiket.FileName);
hataDurumu(false);
end;

procedure TFMain.btnKomutGonderClick(Sender: TObject);
var

  mesaj:integer;
begin

  // ZAMANI SIFIRLAR TÜM ÝÞLEM ÝPTAL OLUR!!!!
  zaman.Enabled:=false;

  //timer'ýn kaç kere döngüye gireceðini belirliyor
  zs:=komutSayisi.Value;

  // DURUM BÝLGÝLERÝ sýfýrlar
  islemDurumu.Position:=0;
  etiketSayisi.Caption:='-';
  durumLabel.Caption:='%0';

  // program baþlðý
  proBaslik:= 'PosLabel 7.15 - ['+EtiketAdi.Text+']';

  // hata durumunu sýfýrla
  hataDurumu(false);


  // iþlem için soru sor
  mesaj:=MessageDlg('Ýþleme devam etmek istiyor musun?..'+#13+#13+'Komut Gönderme esnasýnda MOUSE ve KLAVYE ÇALIÞMAZ !!!!'+#13+#13+'Komut Göndermeyi ÝPTAL etmek için   CTRL+ALT+Del tuþ kombinasyonu yaptýktan sonra 1 kere ESC`ye bas... daha sonrada ALT+F5`e basarsan, PROGRAM KAPANIR!',mtWarning,mbYesNo,0);
  if ( mesaj = mrCancel  ) then exit;
  if ( mesaj = mrno  ) then exit;


  BlockInput(True); //klavye mouse pasif


  // PosLabel programýnýn tam adý handle edilir...
  proHandle := FindWindow(nil,Pchar(proBaslik));


  // pencerenin varlýðýný kontrol ediyor----biii minimize edince kendine gelio yoksa kayboluyor
  if ( ShowWindow(proHandle,SW_SHOWMINIMIZED) = FALSE ) then
  begin
    BlockInput(False); //klavye  mouse aktif
    hataDurumu(true);
    exit; // kod bloðundan çýk iþlem ÝPTAL
  end;

  ShowWindow(proHandle,SW_SHOWNORMAL);

    //-açýk kalmýþ pencere varsa esc ile kapat! ---->>> Burada aktif PRÝNT oluyor!!!!!
  if AppActivate(PWideChar('Print'))=true then
  begin
  SendKeys(PChar('{ESC}'),true);
  end;

  hataDurumu(false);


  // zamana baðlý komut gönderme iþlemleri...baþlatýldý
   zaman.Interval:=1000 * komutAraligi.Value; //saniye olarak hesaplanmýþ olur!
   zaman.Enabled:=true;



end;



procedure TFMain.zamanTimer(Sender: TObject);
var prms,durum1,durum2:string;
   tmpos:integer;

begin

  // BÝTÝÞ ÝÞLEMLERÝ
  if zs <=0 then
  begin
   zaman.Enabled:=false; // timer kapandý.
   BlockInput(False); //klavye  mouse aktif
   ShowMEssage('ÝÞLEM BÝTTÝ');
   exit; // bloktan çýkýldý
  end;

  // program aktif edildiðinde komut gönderilir...
  if AppActivate(PWideChar(proBaslik))=true then
  begin
     Application.ProcessMessages;
     //SendKeys(PChar('{BKSP}'),true);

     SendKeys(PChar('(%fpr)'),true);
     Sleep(1000); //----------------------süreci görmek için yaptým silineilir!...
     //SendKeys(PChar('{ESC}'),true);

     SendKeys(PChar('(%fpp)'),true);

     Dec(zs); // her iþlem sonunda zaman sayacý 1 azalýr.


     // DURUM BÝLGÝLERÝ
     tmpos:=round(( (komutSayisi.Value - zs) / komutSayisi.Value )*100);

     durum1:=Format(' Gönderilen: %d ad.  /  Kalan: %d ad. ',[(komutSayisi.Value - zs),komutSayisi.Value]);
     etiketSayisi.Caption:=durum1;

     durum2:=Format(' %%%d',[tmpos]);
     durumLabel.Caption:=durum2;

     islemDurumu.Position:=tmpos;
     islemDurumu.Update;
  end;


end;



procedure TFMain.H1Click(Sender: TObject);
begin
Fhakkinda.ShowModal;
end;

procedure TFMain.hataDurumu(drm: boolean);
begin
  if (drm=true) then
  begin
    StatusBar1.Panels[1].Text:='Etiket dosyasý bulunamadý!';
    hata.Visible:=true;
  end
    else
  begin
    StatusBar1.Panels[1].Text:='...';
    hata.Visible:=false;
  end
end;

procedure TFMain.N1Click(Sender: TObject);
begin
btnKomutGonderClick(Sender);
end;

procedure TFMain.N3Click(Sender: TObject);
begin
//--
Close();
end;




procedure TFMain.FormCreate(Sender: TObject);
begin
HotKeyID := GlobalAddAtom('HotKey1');
RegisterHotKey(Handle, HotKeyID, MOD_ALT, VK_F5);
// timer'ýn görevini sonlandýrmak için...zaman sayacý
zs:=komutSayisi.Value;
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
UnRegisterHotKey(Handle, HotKeyID);
GlobalDeleteAtom(HotKeyID);
//ShowMessage('');
end;



procedure TFMain.FormShow(Sender: TObject);
begin
// burada oldýuðunda saðlýklý çalýþýyor....
SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
end;

procedure TFMain.WMHotKey(var Msg: TWMHotKey);
begin
Application.Terminate;
end;



end.
