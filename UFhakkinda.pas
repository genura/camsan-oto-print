unit UFhakkinda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TFhakkinda = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fhakkinda: TFhakkinda;

implementation

{$R *.dfm}

procedure TFhakkinda.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=27 then Close;

end;

end.
