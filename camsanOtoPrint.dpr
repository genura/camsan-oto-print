program camsanOtoPrint;

uses
  Forms,
  UFMainnit1 in 'UFMainnit1.pas' {FMain},
  UFhakkinda in 'UFhakkinda.pas' {Fhakkinda};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFhakkinda, Fhakkinda);
  Application.Run;
end.
