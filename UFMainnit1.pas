unit UFMainnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sEdit, Spin, Menus, Buttons, ComCtrls;

type
  TFMain = class(TForm)
    Edit1: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    MainMenu1: TMainMenu;
    D1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Y1: TMenuItem;
    H1: TMenuItem;
    btnKomutGonder: TBitBtn;
    BitBtn2: TBitBtn;
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
    Label10: TLabel;
    Label11: TLabel;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    procedure H1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses UFhakkinda;

{$R *.dfm}

procedure TFMain.H1Click(Sender: TObject);
begin
Fhakkinda.ShowModal;
end;

end.
