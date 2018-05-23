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

    //zaman sayac�
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
//etiket dosyas� i�in dialogu a�
DialogEtiket.Execute();
EtiketAdi.Text:= ExtractFileName (DialogEtiket.FileName);
hataDurumu(false);
end;

procedure TFMain.btnKomutGonderClick(Sender: TObject);
var

  mesaj:integer;
begin

  // ZAMANI SIFIRLAR T�M ��LEM �PTAL OLUR!!!!
  zaman.Enabled:=false;

  //timer'�n ka� kere d�ng�ye girece�ini belirliyor
  zs:=komutSayisi.Value;

  // DURUM B�LG�LER� s�f�rlar
  islemDurumu.Position:=0;
  etiketSayisi.Caption:='-';
  durumLabel.Caption:='%0';

  // program ba�l��
  proBaslik:= 'PosLabel 7.15 - ['+EtiketAdi.Text+']';

  // hata durumunu s�f�rla
  hataDurumu(false);


  // i�lem i�in soru sor
  mesaj:=MessageDlg('��leme devam etmek istiyor musun?..'+#13+#13+'Komut G�nderme esnas�nda MOUSE ve KLAVYE �ALI�MAZ !!!!'+#13+#13+'Komut G�ndermeyi �PTAL etmek i�in   CTRL+ALT+Del tu� kombinasyonu yapt�ktan sonra 1 kere ESC`ye bas... daha sonrada ALT+F5`e basarsan, PROGRAM KAPANIR!',mtWarning,mbYesNo,0);
  if ( mesaj = mrCancel  ) then exit;
  if ( mesaj = mrno  ) then exit;


  BlockInput(True); //klavye mouse pasif


  // PosLabel program�n�n tam ad� handle edilir...
  proHandle := FindWindow(nil,Pchar(proBaslik));


  // pencerenin varl���n� kontrol ediyor----biii minimize edince kendine gelio yoksa kayboluyor
  if ( ShowWindow(proHandle,SW_SHOWMINIMIZED) = FALSE ) then
  begin
    BlockInput(False); //klavye  mouse aktif
    hataDurumu(true);
    exit; // kod blo�undan ��k i�lem �PTAL
  end;

  ShowWindow(proHandle,SW_SHOWNORMAL);

    //-a��k kalm�� pencere varsa esc ile kapat! ---->>> Burada aktif PR�NT oluyor!!!!!
  if AppActivate(PWideChar('Print'))=true then
  begin
  SendKeys(PChar('{ESC}'),true);
  end;

  hataDurumu(false);


  // zamana ba�l� komut g�nderme i�lemleri...ba�lat�ld�
   zaman.Interval:=1000 * komutAraligi.Value; //saniye olarak hesaplanm�� olur!
   zaman.Enabled:=true;



end;



procedure TFMain.zamanTimer(Sender: TObject);
var prms,durum1,durum2:string;
   tmpos:integer;

begin

  // B�T�� ��LEMLER�
  if zs <=0 then
  begin
   zaman.Enabled:=false; // timer kapand�.
   BlockInput(False); //klavye  mouse aktif
   ShowMEssage('��LEM B�TT�');
   exit; // bloktan ��k�ld�
  end;

  // program aktif edildi�inde komut g�nderilir...
  if AppActivate(PWideChar(proBaslik))=true then
  begin
     Application.ProcessMessages;
     //SendKeys(PChar('{BKSP}'),true);

     SendKeys(PChar('(%fpr)'),true);
     Sleep(1000); //----------------------s�reci g�rmek i�in yapt�m silineilir!...
     //SendKeys(PChar('{ESC}'),true);

     SendKeys(PChar('(%fpp)'),true);

     Dec(zs); // her i�lem sonunda zaman sayac� 1 azal�r.


     // DURUM B�LG�LER�
     tmpos:=round(( (komutSayisi.Value - zs) / komutSayisi.Value )*100);

     durum1:=Format(' G�nderilen: %d ad.  /  Kalan: %d ad. ',[(komutSayisi.Value - zs),komutSayisi.Value]);
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
    StatusBar1.Panels[1].Text:='Etiket dosyas� bulunamad�!';
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
// timer'�n g�revini sonland�rmak i�in...zaman sayac�
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
// burada old�u�unda sa�l�kl� �al���yor....
SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NoMove or SWP_NoSize);
end;

procedure TFMain.WMHotKey(var Msg: TWMHotKey);
begin
Application.Terminate;
end;



end.
