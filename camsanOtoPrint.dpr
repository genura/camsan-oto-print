program camsanOtoPrint;

uses
  Forms,
  UFMainnit1 in 'UFMainnit1.pas' {FMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
