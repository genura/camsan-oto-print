program camsanOtoPrint;

uses
  Forms,
  JclAppInst,
  UFMainnit1 in 'UFMainnit1.pas' {FMain},
  UFhakkinda in 'UFhakkinda.pas' {Fhakkinda},
  sndkey32tr in 'sndkey32tr.pas';

{$R *.res}

begin
  JclAppInstances.CheckSingleInstance; // Added instance checking---bu kadar mk
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFhakkinda, Fhakkinda);
  Application.Run;
end.
