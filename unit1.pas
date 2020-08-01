unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus, LCLType;

type

  { TBTextEditor }

  TBTextEditor = class(TForm)
    EditField: TMemo;
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveFileMenuItem: TMenuItem;
    SaveAsMenuItem: TMenuItem;
    OpenFileMenuItem: TMenuItem;
    CreateFileMenuItem: TMenuItem;
    PrefSubMenu: TMenuItem;
    FontMenu: TMenuItem;
    StatsLbl: TLabel;
    procedure CreateFileMenuItemClick(Sender: TObject);
    procedure EditFieldChange(Sender: TObject);
    procedure FontMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OpenFileMenuItemClick(Sender: TObject);
    procedure chSave;
    procedure SaveAsMenuItemClick(Sender: TObject);
    procedure SaveFileMenuItemClick(Sender: TObject);
    procedure updmeta;
  private

  public
    TextSaved:Boolean;
    PathKnown:Boolean;
    Path:String;
    f:text;
    fonts:array[1..5] of integer;
  end;

var
  BTextEditor: TBTextEditor;

implementation

{$R *.lfm}

{ TBTextEditor }

procedure TBTextEditor.updmeta;
var savedcap, pathcap:string;
begin
     if textsaved then savedcap:= 'changes saved.' else savedcap:='unsaved changes.';
     if pathknown then pathcap:=path else pathcap:='Unknown file' ;
   StatsLbl.caption:=pathcap+' '+inttostr(length(editfield.text))+' characters, '+inttostr(editfield.lines.count)+' lines, '+savedcap;;
end;

procedure TBTextEditor.OpenFileMenuItemClick(Sender: TObject);
var b:string;
begin
    chSave;
    if opendialog1.execute then begin
      path:=opendialog1.filename;
      pathknown:=true;
      assignfile(f,path);
      EditField.Lines.Clear;
      reset(f);
      while not eof(f) do begin
           readln(f,b);
           editfield.lines.add(b);
      end;
      textsaved:=true;
      closefile(f);
    end;
    updmeta;
end;

procedure TBTextEditor.chSave;
var reply:integer;
begin
    if not textsaved then begin
      reply:=application.messagebox('Save changes?', 'BTextEditor', MB_ICONQUESTION + MB_YESNO);
      if reply=IDYES then  begin if pathknown then begin
       assignfile(f, path);
       rewrite(f);
       write(f, editfield.text);
       textsaved:=true;
       closefile(f);
       Application.MessageBox('Your changes have been saved!', 'BTextEditor');
    end else SaveAsMenuItemClick(Self); end; end;
    updmeta
end;

procedure TBTextEditor.SaveAsMenuItemClick(Sender: TObject);
begin
     if(savedialog1.execute) then begin
          path:=savedialog1.filename;
          pathknown:=true;
          assignfile(f, path);
          rewrite(f);
          write(f, editfield.text);
          closefile(f);
          textsaved:=true;
     end;
     updmeta;
end;

procedure TBTextEditor.SaveFileMenuItemClick(Sender: TObject);
begin
     chSave;
end;

procedure TBTextEditor.CreateFileMenuItemClick(Sender: TObject);
begin
    chSave;
    editfield.lines.clear;
    pathknown:=false;
    updmeta;
end;

procedure TBTextEditor.EditFieldChange(Sender: TObject);
begin
  textsaved:=false;
  updmeta;
end;

procedure TBTextEditor.FontMenuClick(Sender: TObject);
begin
  if(fontdialog1.execute) then begin
      editfield.font:=fontdialog1.font;
  end;

end;

procedure TBTextEditor.FormCreate(Sender: TObject);
begin

  editField.text:='';
  pathknown:=false; textsaved:=true;
  updmeta;
end;

end.

