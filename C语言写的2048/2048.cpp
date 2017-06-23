#include <windows.h>
#include <tchar.h>//_tcschr
#include <stdio.h>//fread
#include <CommCtrl.h>//����ؼ���ʽ
#include <mmsystem.h>
#include "Resource.h"//��Դ
#include "ControlStyle.h"//�嵥�ļ�
#pragma comment(lib, "WINMM.LIB")

const int width=400;
const int height=600;

const int redo_num=20;//��ʵ��������Ҫ��1
#define STEP_BEFORE_DEAD 5//��ǰ��n��
#define RANDOM_STEP_THRESHOLD 8//���ģʽ�³���8�������Լ����
#define REDO_SHRESHOLD 10000//���������ż� Ĭ��10000�ֵ�һ�γ�������
#define HIGHSCORE_COUNT 10//���а�����
#define HIGHSCORE_THRESHOLD 1000//����1000�ֲ�����߷ְ�
#define MAX_NAME_LENGTH 64//�����������

#define BIRTHNEW 1//�����¿��ʱ��ID
#define FRAMETIME 10//����ÿ֡ʱ�䣨���룩
const int margin_y1=26;

const int score_w=121;
const int score_h=70;

const int score_x=130;
const int score_margin_x=6;

const int vcenter_h=68;

const int border=15;
const int block=80;

const int bottom_text_h=25;

int iblock;//���϶

const int round=5;//Բ�ǰ뾶

int button_w;
const int button_h=20;
const int button_s=5;

//��ɫ��
RECT rectName;
RECT rectScore,rectBest;
RECT rectScoreTitle,rectScoreNum;
RECT rectBestTitle,rectBestNum;
RECT rectMain;
RECT rect[4][4];
RECT rectVCenterText;
RECT rectBottomText;
//������
HWND hwnd;

//�ؼ�
#define BNUM 5//��ť����
HWND hwndButton[BNUM];
RECT rectButton[BNUM];

struct
{
	TCHAR Name[sizeof(TCHAR)==1U?13:8];//ansiΪ10��unicodeΪ8
} sButton[BNUM]=
{
	TEXT("����Ϸ"),//0
	//	TEXT("����"),
	TEXT("�������"),
	TEXT("����(0)"),//2
	TEXT("���а�"),//3
	TEXT("˵��")//4
};
#define NEWGAME 0
#define RANDOMGAME 1
#define REDO 2
#define HIGHSCORE 3
#define README 4

int onmouse=-1;//�����ͣ��ťID��δ��ͣΪ-1
bool onrandom=false;

//����
HINSTANCE hInst;
unsigned int num[4][4]={0};
unsigned int step=0,step_after_random;
unsigned long score=0;
unsigned long high_score=0;
bool has_record_score=false;

static TCHAR buffer_temp[10];
unsigned int newnum_index=0;

//���а�
struct
{
	TCHAR name[MAX_NAME_LENGTH];
	unsigned long score;
} sHighScore[HIGHSCORE_COUNT];

TCHAR szFilePath[255];
TCHAR szHighScore[sizeof(sHighScore)*HIGHSCORE_COUNT];

//��������
unsigned int can_redo=0;//��ҿɳ�������
unsigned int redo_count=0;//������������
unsigned int redo_score=0;//��������
struct 
{
	unsigned int score;
	unsigned int num[4][4];
}redo[redo_num];

//�豸��ز���
int cxScreen,cyScreen,cyCaption,cxSizeFrame,cySizeFrame;

//����
const TCHAR FontName[]=TEXT("΢���ź�");//����

//��ɫ
const unsigned long crWhite=RGB(255,255,255);//��ɫ
const unsigned long crBackground=RGB(250,248,239);//������ɫ
const unsigned long crGray=RGB(187,173,160);//������
const unsigned long crText=RGB(115,106,98);//��ɫ����2048
const unsigned long crScoreTitle=RGB(245,235,226);//��߷�
const unsigned long crLessEqual8=RGB(119,110,101);//���ֵ���8Ϊ��ɫ������8Ϊ��ɫ
const unsigned long cr2=RGB(238,228,218);
const unsigned long cr4=RGB(237,224,200);
const unsigned long cr8=RGB(242,177,121);
const unsigned long cr16=RGB(245,149,99);
const unsigned long cr32=RGB(246,124,95);
const unsigned long cr64=RGB(246,94,59);
const unsigned long cr128=RGB(237,204,97);
const unsigned long cr256=cr128;
const unsigned long cr512=cr128;
const unsigned long cr1024=cr128;
const unsigned long cr2048=RGB(237,194,46);

//declare
unsigned long Num2Color(unsigned int num);
void CopyArray(unsigned int result[4][4],unsigned int source[4][4]);
bool isAll0(unsigned int num[4][4]);
void NewRecord();
void Redo();
bool InHighScore();
TCHAR * int2ptchar(unsigned int i);
bool isDead();
void FillRectAdvance(HDC hdc,RECT *rect,unsigned long color);
void NewNum();
bool AskStartNewGame();
bool JudgeFreshHighScore();
void JudgeAction(HWND hwnd,bool move);
void DrawTextAdvance(HDC hdc,TCHAR text[],RECT *rect,long FontSize,int FontWeight,unsigned long color,const TCHAR FontName[],UINT format);
void FreshRedoButton();
void FreshHighScore(TCHAR szName[]);
void SaveGame();
LRESULT CALLBACK WndProc (HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK ChildWndProc (HWND, UINT, WPARAM , LPARAM);
BOOL CALLBACK AboutDlgProc(HWND hDlg,UINT message,WPARAM wParam,LPARAM lParam);
BOOL CALLBACK NameDlgProc(HWND hDlg,UINT message,WPARAM wParam,LPARAM lParam);

unsigned long Num2Color(unsigned int num)
{
	switch (num)
	{
	case 2:return cr2;break;
	case 4:return cr4;break;
	case 8:return cr8;break;
	case 16:return cr16;break;
	case 32:return cr32;break;
	case 64:return cr64;break;
	case 128:return cr128;break;
	case 256:return cr256;break;
	case 512:return cr512;break;
	case 1024:return cr1024;break;
	case 2048:return cr2048;break;
	default:return cr2048;break;
	}
}

void CopyArray(unsigned int result[4][4],unsigned int source[4][4])
{
	for (int i=0;i<4;i++)
		for (int j=0;j<4;j++)
			result[i][j]=source[i][j];
}

void NewRecord()
{
	for (int i=min(step,redo_num-1);i>=1;i--)
	{
		CopyArray(redo[i].num,redo[i-1].num);
		redo[i].score=redo[i-1].score;
	}
	CopyArray(redo[0].num,num);
	redo[0].score=score;
	if (redo_count<redo_num-1) redo_count++;
	step++;
	step_after_random++;
}

bool isAll0(unsigned int num[4][4])
{
	for (int i=0;i<4;i++)
		for (int j=0;j<4;j++)
			if (num[i][j]!=0)
			{
				return false;
			}
			return true;
}

void Redo()
{
	if (isAll0(redo[1].num)==false)//��ȫ��
	{
		CopyArray(num,redo[1].num);
		score=redo[1].score;
		for (int i=0;i<=redo_num-2;i++)
		{
			CopyArray(redo[i].num,redo[i+1].num);
			redo[i].score=redo[i+1].score;
		}
		for (int i=0;i<4;i++)
			for (int j=0;j<4;j++)
				redo[min(step,redo_num-1)].num[i][j]=0;
		redo[min(step,redo_num-1)].score=0;
	}
}

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
	hInst=hInstance;
	//��ó���·��
	GetModuleFileName(NULL,szFilePath,sizeof(szFilePath));
	(_tcsrchr(szFilePath, _T('\\')))[1] = 0;
	lstrcat(szFilePath,TEXT("2048.SAV"));

	//���ϵͳ����
	cxScreen = GetSystemMetrics(SM_CXSCREEN);
	cyScreen = GetSystemMetrics(SM_CYSCREEN);
	cyCaption=GetSystemMetrics(SM_CYCAPTION);
	cxSizeFrame=GetSystemMetrics(SM_CXSIZEFRAME);
	cySizeFrame=GetSystemMetrics(SM_CYSIZEFRAME);

	static TCHAR szAppName[] = TEXT("2048");

	MSG    msg ;
	WNDCLASS wndclass ;
	wndclass.style        = CS_HREDRAW | CS_VREDRAW ;
	wndclass.lpfnWndProc  = WndProc ;
	wndclass.cbClsExtra   = 0 ;
	wndclass.cbWndExtra   = 0 ;
	wndclass.hInstance    = hInstance ;
	wndclass.hIcon        = LoadIcon(hInstance,MAKEINTRESOURCE(IDI_ICONSMALL));
	wndclass.hCursor      = LoadCursor (NULL, IDC_ARROW) ;
	wndclass.hbrBackground= CreateSolidBrush(crBackground);
	wndclass.lpszMenuName  = NULL ;
	wndclass.lpszClassName= szAppName ;

	if (!RegisterClass (&wndclass))
	{
		MessageBox (NULL, TEXT ("This program requires Windows NT!"),szAppName, MB_ICONERROR) ;
		return 0 ;
	}

	wndclass.lpfnWndProc   = ChildWndProc ;
	wndclass.cbWndExtra    = sizeof (long) ;
	wndclass.hIcon         = NULL ;
	wndclass.lpszClassName = TEXT("szChildClass") ;

	RegisterClass (&wndclass) ;

	hwnd = CreateWindow(szAppName,
		TEXT ("2048 PC���ٰ�1.0  by Tom Willow"),
		WS_OVERLAPPED|WS_SYSMENU|WS_CAPTION|WS_MINIMIZEBOX,
		(cxScreen-width)/2,
		(cyScreen-height)/2,
		width+2*cxSizeFrame,//win7�¿�ȴ�10��xp�¿�ȴ�n��δ������
		height+cyCaption+2*cySizeFrame,//-10
		NULL,
		NULL,
		hInstance,
		NULL);

	ShowWindow (hwnd, iCmdShow) ;
	UpdateWindow (hwnd) ;

	while (GetMessage (&msg, NULL, 0, 0))
	{
		TranslateMessage (&msg) ;
		DispatchMessage (&msg) ;
	}
	return msg.wParam ;
}

TCHAR * int2ptchar(unsigned int i)
{
	wsprintf(buffer_temp,TEXT("%d"),i);
	return buffer_temp;
}

void FreshRedoButton()
{
	wsprintf(sButton[REDO].Name,TEXT("����(%d)"),can_redo);
	EnableWindow(hwndButton[REDO],can_redo>0?true:false);
	InvalidateRect(hwndButton[REDO],NULL,true);
}
bool isDead()
{
	for (int i=0;i<4;i++)
		for (int j=0;j<4;j++)
			if (num[i][j]==0)
				return false;
	for (int i=0;i<4;i++)
		for (int j=0;j<3;j++)
			if (num[i][j]==num[i][j+1])
			{
				return false;
				break;
			}
			for (int i=0;i<4;i++)
				for (int j=0;j<3;j++)
					if (num[j][i]==num[j+1][i])
					{
						return false;
						break;
					}
					return true;
}

void FillRectAdvance(HDC hdc,RECT *rect,unsigned long color)
{
	HBRUSH hBrush;
	hBrush=CreateSolidBrush(color);
	FillRect(hdc,rect,hBrush);
	DeleteObject(hBrush);
}

void FreshMainRect()
{
	HDC hdc;
	hdc=GetDC(hwnd);

	SetBkMode(hdc,TRANSPARENT);
	HBRUSH hBrush=CreateSolidBrush(crGray);
	HPEN hPen=CreatePen(PS_NULL,0,0);
	SelectObject(hdc,hBrush);//�����鱳��
	SelectObject(hdc,hPen);//ȥ������
	//������
	RoundRect(hdc,rectMain.left,rectMain.top,rectMain.right,rectMain.bottom,round,round);

	for (int i=0;i<4;i++)
		for (int j=0;j<4;j++)
		{
			if (num[i][j]!=0)
			{
				FillRectAdvance(hdc,&rect[i][j],Num2Color(num[i][j]));
				DrawTextAdvance(hdc,int2ptchar(num[i][j]),&rect[i][j],(num[i][j]<1024)?26:18,700,(num[i][j]<=8)?crLessEqual8:crWhite,FontName,DT_CENTER|DT_SINGLELINE|DT_VCENTER);
			}
		};

	DeleteObject(hBrush);
	DeleteObject(hPen);
	ReleaseDC(hwnd,hdc);
}

void NewNum()
{
	unsigned int *p;
	int zero[16];//�հ׸�
	int j=0;
	p=&num[0][0];
	for (int i=0;i<16;i++)
		if (*(p+i)==0)
		{
			zero[j]=i;//˳����¿հ׸�����
			j++;
		};
	if (j!=0)
	{
		srand(GetTickCount());
		newnum_index=zero[rand() % j];
		p+=newnum_index;
		FreshMainRect();//��ˢ�»����ٳ��¿�
		*p=(rand()%2)?2:4;
		SetTimer(hwnd,BIRTHNEW,FRAMETIME,NULL);
	}
}

bool AskStartNewGame()
{
	TCHAR buffer[100];
	TCHAR title[10];
	if (isDead())
	{
		wsprintf(buffer,TEXT("û�п��ƶ��Ŀ��ˡ�\n�Ƿ�ʼ����Ϸ��\n��������%d�γ������ᣩ"),can_redo);
		lstrcpy(title,TEXT("��Ϸ����"));
	}
	else
	{
		lstrcpy(buffer,TEXT("�Ƿ�ʼ����Ϸ��"));
		lstrcpy(title,TEXT("����Ϸ"));
	}
	MessageBeep(0);
	if (IDYES==MessageBox(hwnd,buffer,title,MB_YESNO|MB_ICONQUESTION))
	{
		return true;
	}
	else
	{
		return false;
	}
}

void Fill0(HWND hwnd)
{
	for (int i=0;i<4;i++)
		for (int j=0;j<4;j++)
			num[i][j]=0;
	NewNum();
	NewRecord();

	onrandom=false;
	score=0;
	redo_score=0;
	can_redo=0;
	redo_count=0;
	has_record_score=false;
	FreshRedoButton();
	SaveGame();
	//InvalidateRect(hwnd,NULL,true);
}

bool InHighScore()
{
	if (score>=sHighScore[HIGHSCORE_COUNT-1].score)
		return true;
	else
		return false;
}

bool JudgeFreshHighScore()//����false��������ɼ�
{
	if (step!=step_after_random && step_after_random<RANDOM_STEP_THRESHOLD)//����ﵽ�����洢��������������Լ���ģ���������Ϊ�������
	{
		FreshHighScore(TEXT("���"));
		return false;
	}
	else
	{
		DialogBox(hInst,TEXT("IDD_DIALOGNAME"),hwnd,NameDlgProc);
		return true;
	}
}

void FreshHighScore(TCHAR szName[])
{
	unsigned long temp=0;
	TCHAR temp_name[MAX_NAME_LENGTH];
	int i=0;
	for (i=0;i<HIGHSCORE_COUNT;i++)
	{
		if (score>=sHighScore[i].score)
		{
			//����
			high_score=max(score,sHighScore[0].score);//������һ��ˢ����߷�

			temp=sHighScore[i].score;
			lstrcpy(temp_name,sHighScore[i].name);//��ǰ���д�����ʱ����

			sHighScore[i].score=score;
			lstrcpy(sHighScore[i].name,szName);//ˢ�����а�
			has_record_score=true;
			break;
		}
	}
	if (temp>0)//else�Ļ�û�и��°�
	{
		for (int j=HIGHSCORE_COUNT-1;j>i+1;j--)
		{
			sHighScore[j].score=sHighScore[j-1].score;
			lstrcpy(sHighScore[j].name,sHighScore[j-1].name);
		}
		sHighScore[i+1].score=temp;
		lstrcpy(sHighScore[i+1].name,temp_name);
	}
}

void JudgeAction(HWND hwnd,bool move)//���з�������ᾭ���˴�
{
	if (move)
	{
		NewNum();
		NewRecord();
		if (redo_score>=REDO_SHRESHOLD)//ÿ��һ��ֵ�һ�γ������ᣬһ�κϳɳ�����1���Ҳֻ��һ��
		{
			can_redo+=(can_redo<=redo_num-2)?1:0;//������ڿɳ��������򲻼Ӵ����������۷���ȻҪ����
			FreshRedoButton();
			redo_score=redo_score % REDO_SHRESHOLD;
		}
		if (onrandom!=true)
			high_score=max(score,high_score);
		InvalidateRect(hwnd,&rectScore,true);
		InvalidateRect(hwnd,&rectBest,true);
		//InvalidateRect(hwnd,&rectMain,true);
		if (onrandom==false) PlaySound((LPCTSTR)IDR_WAVE1,hInst,SND_RESOURCE|SND_ASYNC|SND_NOSTOP);//
		if (isDead())
		{
			if (onrandom!=true)//��������
			{
				if (InHighScore() && score>=HIGHSCORE_THRESHOLD)//����߷ְ񣬴���1000��
				{
					if (can_redo==0)
					{
						if (JudgeFreshHighScore()==false)//����ɼ���������ɼ��������а��ֶ�����
							if (AskStartNewGame()==true)
							{
								Fill0(hwnd);
							}
					}
					else
					{
						if (AskStartNewGame()==true)
						{
							JudgeFreshHighScore();
							Fill0(hwnd);
						}
					}
				}
				else//û�н���߷ְ�
				{
					if (AskStartNewGame()==true)
						Fill0(hwnd);
				}
			}
			else//�������
			{
			}
		}
	}
	else//û�в����ƶ���������������
	{
		if (isDead())//�������ٴ�û�пɵ�Ŀ鵽������
			SendMessage(hwndButton[NEWGAME],WM_LBUTTONDOWN,0,0);
	}
}
void DrawTextAdvance(HDC hdc,TCHAR text[],RECT *rect,long FontSize,int FontWeight,unsigned long color,const TCHAR FontName[],UINT format)
{
	long lfHeight;
	HFONT hf;
	lfHeight = -MulDiv(FontSize, GetDeviceCaps(hdc, LOGPIXELSY), 72);
	hf = CreateFont(lfHeight, 0, 0, 0, FontWeight, 0, 0, 0, 0, 0, 0, 0, 0, FontName);
	SelectObject(hdc,hf);
	SetTextColor(hdc,color);
	DrawText(hdc,text,-1,rect,format);
	DeleteObject(hf);
}

LRESULT CALLBACK WndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
	case WM_CREATE:
		//�ؼ���ʼ��
		InitCommonControls();

		//���ڴ�С���������û������򴰿ڴ�С����ȷ
		RECT ClientRect,WindowRect;
		int dx,dy;
		GetClientRect(hwnd,&ClientRect);
		GetWindowRect(hwnd,&WindowRect);
		dx=ClientRect.right-width;
		dy=ClientRect.bottom-height;
		SetWindowPos(hwnd,NULL,(cxScreen-width)/2,(cyScreen-height)/2,(WindowRect.right-WindowRect.left)-dx,(WindowRect.bottom-WindowRect.top)-dy,0);

		rectName.left=border;
		rectName.top=margin_y1;
		rectName.right=score_x-score_margin_x;
		rectName.bottom=rectName.top+score_h;

		rectScore.left=score_x;
		rectScore.top=margin_y1;
		rectScore.right=rectScore.left+score_w;
		rectScore.bottom=rectScore.top+score_h;

		SetRect(&rectScoreTitle,rectScore.left,rectScore.top,rectScore.right,int(rectScore.top+0.4*(rectScore.bottom-rectScore.top)));
		SetRect(&rectScoreNum,rectScore.left,int(rectScore.top+0.4*(rectScore.bottom-rectScore.top)),rectScore.right,rectScore.bottom);

		rectBest.right=width-border;
		rectBest.left=rectBest.right-score_w;
		rectBest.top=margin_y1;
		rectBest.bottom=rectBest.top+score_h;

		SetRect(&rectBestTitle,rectBest.left,rectBest.top,rectBest.right,int(rectBest.top+0.4*(rectBest.bottom-rectBest.top)));
		SetRect(&rectBestNum,rectBest.left,int(rectBest.top+0.4*(rectBest.bottom-rectBest.top)),rectBest.right,rectBest.bottom);

		rectVCenterText.left=border;
		rectVCenterText.right=width-border;
		rectVCenterText.top=rectScore.bottom;
		rectVCenterText.bottom=rectVCenterText.top+vcenter_h;

		rectMain.left=border;
		rectMain.right=width-border;
		rectMain.top=rectVCenterText.bottom;
		rectMain.bottom=rectMain.top+(rectMain.right-rectMain.left);

		iblock=((rectMain.right-rectMain.left)-block*4)/5;

		for (int i=0;i<4;i++)
			for (int j=0;j<4;j++)
			{
				rect[i][j].left=rectMain.left+(j+1)*iblock+j*block;
				rect[i][j].right=rect[i][j].left+block;
				rect[i][j].top=rectMain.top+(i+1)*iblock+i*block;
				rect[i][j].bottom=rect[i][j].top+block;
			}

			rectBottomText.left=rectMain.left;
			rectBottomText.right=rectMain.right;
			rectBottomText.top=rectMain.bottom;
			rectBottomText.bottom=rectBottomText.top+bottom_text_h;

			button_w=(width-2*border-(BNUM-1)*button_s)/BNUM;//��-2���߿� -5����϶button_s

			for (int i=0;i<BNUM;i++)
			{
				rectButton[i].top=height-border-button_h;
				rectButton[i].bottom=height-border;
				rectButton[i].left=border+i*button_s+i*button_w;//�߾�+��϶+��ť��
				rectButton[i].right=rectButton[i].left+button_w;
				hwndButton[i] =CreateWindow(
					TEXT("szChildClass"),
					sButton[i].Name,
					WS_CHILD | WS_VISIBLE | BS_OWNERDRAW,//BS_PUSHBUTTON
					rectButton[i].left,
					rectButton[i].top,
					button_w,
					button_h,
					hwnd, (HMENU) i,
					((LPCREATESTRUCT) lParam)->hInstance,
					NULL);
			}

			FILE *file;
			if (_tfopen_s(&file,szFilePath,TEXT("r,ccs=UNICODE"))==0)//�ɹ���Ϊ0
			{
				fread(sHighScore,sizeof(sHighScore),1,file);
				fread(num,sizeof(num),1,file);
				fread(&step,sizeof(step),1,file);
				fread(&step_after_random,sizeof(step_after_random),1,file);
				fread(&score,sizeof(score),1,file);
				fread(&high_score,sizeof(high_score),1,file);
				fread(&has_record_score,sizeof(has_record_score),1,file);
				fread(redo,sizeof(redo),1,file);
				fread(&can_redo,sizeof(can_redo),1,file);
				fread(&redo_score,sizeof(redo_score),1,file);
				fread(&redo_count,sizeof(redo_score),1,file);
				_fcloseall();
				FreshRedoButton();
			}

			if (step==0)
				Fill0(hwnd);

			return 0;

	case WM_PAINT:
		HDC hdc;
		PAINTSTRUCT ps ;
		hdc = BeginPaint(hwnd, &ps);

		SetBkMode(hdc,TRANSPARENT);

		HBRUSH hBrush;
		hBrush=CreateSolidBrush(crGray);
		SelectObject(hdc,hBrush);//�����鱳��

		HPEN hPen;
		hPen=CreatePen(PS_NULL,0,0);
		SelectObject(hdc,hPen);//ȥ������

		DrawTextAdvance(hdc,TEXT("2048"),&rectName,34,0,crText,FontName,DT_CENTER|DT_VCENTER|DT_SINGLELINE);


		//��������
		RoundRect(hdc,rectScore.left,rectScore.top,rectScore.right,rectScore.bottom,round,round);

		DrawTextAdvance(hdc,TEXT("����"),&rectScoreTitle,12,700,crScoreTitle,FontName,DT_CENTER|DT_SINGLELINE|DT_BOTTOM);
		DrawTextAdvance(hdc,int2ptchar(score),&rectScoreNum,24,0,crWhite,FontName,DT_CENTER|DT_SINGLELINE|DT_TOP);

		//����߷ֿ�
		RoundRect(hdc,rectBest.left,rectBest.top,rectBest.right,rectBest.bottom,round,round);

		DrawTextAdvance(hdc,TEXT("��߷�"),&rectBestTitle,12,700,crScoreTitle,FontName,DT_CENTER|DT_SINGLELINE|DT_BOTTOM);
		DrawTextAdvance(hdc,int2ptchar(high_score),&rectBestNum,24,0,crWhite,FontName,DT_CENTER|DT_SINGLELINE|DT_TOP);

		DrawTextAdvance(hdc,TEXT("����Щ���ϳ�2048��"),&rectVCenterText,13,0,crText,FontName,DT_LEFT|DT_SINGLELINE|DT_VCENTER);
		DrawTextAdvance(hdc,TEXT("�淨���������ң��ƶ�ɫ�飬�ϳ���������֣�"),&rectBottomText,13,0,crText,FontName,DT_LEFT|DT_SINGLELINE|DT_VCENTER);

		//������
		RoundRect(hdc,rectMain.left,rectMain.top,rectMain.right,rectMain.bottom,round,round);

		for (int i=0;i<4;i++)
			for (int j=0;j<4;j++)
			{
				if (num[i][j]!=0)
				{
					FillRectAdvance(hdc,&rect[i][j],Num2Color(num[i][j]));
					DrawTextAdvance(hdc,int2ptchar(num[i][j]),&rect[i][j],(num[i][j]<1024)?26:18,700,(num[i][j]<=8)?crLessEqual8:crWhite,FontName,DT_CENTER|DT_SINGLELINE|DT_VCENTER);
				}
			}

			DeleteObject(hBrush);
			DeleteObject(hPen);
			EndPaint(hwnd, &ps);
			return 0 ;
	case WM_TIMER:
		{
			switch (wParam)
			{
			case BIRTHNEW:
				static int count=0;
				if (count<=10 && ( *(&num[0][0]+newnum_index)==2 || *(&num[0][0]+newnum_index)==4))
				{
					HDC hdc;
					hdc=GetDC(hwnd);
					SetBkMode(hdc,TRANSPARENT);
					RECT rectnewnum_index;

					rectnewnum_index.left=rect[newnum_index/4][newnum_index%4].left+block/2*(1-count/10.0);
					rectnewnum_index.right=rect[newnum_index/4][newnum_index%4].left+block/2*(1+count/10.0);
					rectnewnum_index.top=rect[newnum_index/4][newnum_index%4].top+block/2*(1-count/10.0);
					rectnewnum_index.bottom=rect[newnum_index/4][newnum_index%4].top+block/2*(1+count/10.0);

					FillRectAdvance(hdc,&rectnewnum_index,Num2Color(*(&num[0][0]+newnum_index)));
					DrawTextAdvance(hdc,int2ptchar(*(&num[0][0]+newnum_index)),&rectnewnum_index,((*(&num[0][0]+newnum_index)<1024)?26:18)*(count/10.0),700,(*(&num[0][0]+newnum_index)<=8)?crLessEqual8:crWhite,FontName,DT_CENTER|DT_SINGLELINE|DT_VCENTER);

					ReleaseDC(hwnd,hdc);
					count++;
				}
				else
				{
					KillTimer(hwnd,BIRTHNEW);
					count=0;
					//InvalidateRect(hwnd,&rectMain,FALSE);
				}
				break;
			}
			return 0;
		}
	case WM_KEYDOWN:
		switch (wParam)
		{
		case VK_UP:
			{
				bool move=false;
				int now=0;
				int temp=1;
				for (int j=0;j<4;j++)
				{
					now=0;
					temp=1;
					while ((now<4)&&(temp<4))
					{
						if (num[now][j]==0)
						{
							if (num[temp][j]!=0)
							{
								move=true;
								num[now][j]=num[temp][j];
								num[temp][j]=0;
								now++;
								temp=now+1;
							}
							else
							{
								temp++;
							}
						}
						else
						{
							now++;
							temp=now+1;
						}
					}//��������ƶ�
					for (int i=0;i<3;i++)
					{
						if (num[i][j]==num[i+1][j]&&num[i][j]!=0)//�е÷ֿ�
						{
							move=true;
							num[i][j]*=2;
							score+=num[i][j];
							redo_score+=num[i][j];
							for (int n=i+1;n<3;n++)//�׷�����
								num[n][j]=num[n+1][j];
							num[3][j]=0;
						}
					}
				}
				JudgeAction(hwnd,move);
				break;
			}
		case VK_DOWN:
			{
				bool move=false;
				int now=0;
				int temp=1;
				for (int j=0;j<4;j++)
				{
					now=3;
					temp=2;
					while ((now>-1)&&(temp>-1))
					{
						if (num[now][j]==0)//now����ǰָ��
						{
							if (num[temp][j]!=0)
							{
								move=true;
								num[now][j]=num[temp][j];
								num[temp][j]=0;
								now--;
								temp=now-1;
							}
							else
							{
								temp--;
							}
						}
						else
						{
							now--;
							temp=now-1;
						}
					}//��������ƶ�
					for (int i=3;i>0;i--)
					{
						if (num[i][j]==num[i-1][j]&&num[i][j]!=0)
						{
							move=true;
							num[i][j]*=2;
							score+=num[i][j];
							redo_score+=num[i][j];
							for (int n=i-1;n>0;n--)//�Ϸ�����
								num[n][j]=num[n-1][j];
							num[0][j]=0;
						}
					}
				}
				JudgeAction(hwnd,move);
				break;
			}
		case VK_LEFT:
			{
				bool move=false;
				int now=0;
				int temp=1;
				for (int i=0;i<4;i++)
				{
					now=0;
					temp=1;
					while ((now<4)&&(temp<4))
					{
						if (num[i][now]==0)
						{
							if (num[i][temp]!=0)
							{
								move=true;
								num[i][now]=num[i][temp];
								num[i][temp]=0;
								now++;
								temp=now+1;
							}
							else
							{
								temp++;
							}
						}
						else
						{
							now++;
							temp=now+1;
						}
					}//��������ƶ�
					for (int j=0;j<3;j++)
					{
						if (num[i][j]==num[i][j+1]&&num[i][j]!=0)
						{
							move=true;
							num[i][j]*=2;
							score+=num[i][j];
							redo_score+=num[i][j];
							for (int n=j+1;n<3;n++)//������
								num[i][n]=num[i][n+1];
							num[i][3]=0;
						}
					}
				}
				JudgeAction(hwnd,move);
				break;
			}
		case VK_RIGHT:
			{
				bool move=false;
				int now=0;
				int temp=1;
				for (int i=0;i<4;i++)
				{
					now=3;
					temp=2;
					while ((now>-1)&&(temp>-1))
					{
						if (num[i][now]==0)//now����ǰָ��
						{
							if (num[i][temp]!=0)
							{
								move=true;
								num[i][now]=num[i][temp];
								num[i][temp]=0;
								now--;
								temp=now-1;
							}
							else
							{
								temp--;
							}
						}
						else
						{
							now--;
							temp=now-1;
						}
					}//��������ƶ�
					for (int j=3;j>0;j--)
					{
						if (num[i][j]==num[i][j-1]&&num[i][j]!=0)
						{
							move=true;
							num[i][j]*=2;
							score+=num[i][j];
							redo_score+=num[i][j];
							for (int n=j-1;n>0;n--)//����
								num[i][n]=num[i][n-1];
							num[i][0]=0;
						}
					}
				}
				JudgeAction(hwnd,move);
				break;
			}
		case VK_RETURN:
		case VK_SPACE:
			SendMessage(hwnd,WM_KEYDOWN,0x25+(rand() % 4),0);//�����4�������
			break;
		}
		return 0;
	case WM_MOUSEMOVE:
		onmouse=-1;
		for (int i=0;i<BNUM;i++)
			InvalidateRect(hwndButton[i],NULL,false);
		return 0;
	case WM_CLOSE:
		MessageBeep(0);
		if (IDOK==MessageBox(hwnd,TEXT("�Ƿ��˳���\n����ǰ��Ϸ�������棩"),TEXT("�˳�"),MB_OKCANCEL|MB_ICONQUESTION))
		{
			//�˳������б����ļ�
			SaveGame();
			break;//����switch��ִ��DefWindowProc���˳�
		}
		else
		{
			return 0;//������Ϣ�����˳�
		}
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0 ;
	case WM_QUIT:
		return 0;
	}

	return DefWindowProc (hwnd, message, wParam, lParam);
}

void SaveGame()
{
	FILE *file;
	if (_tfopen_s(&file,szFilePath,TEXT("w+,ccs=UNICODE"))==0)//�ɹ���Ϊ0
	{
		fwrite(sHighScore,sizeof(sHighScore),1,file);
		fwrite(num,sizeof(num),1,file);
		fwrite(&step,sizeof(step),1,file);
		fwrite(&step_after_random,sizeof(step_after_random),1,file);
		fwrite(&score,sizeof(score),1,file);
		fwrite(&high_score,sizeof(high_score),1,file);
		fwrite(&has_record_score,sizeof(has_record_score),1,file);
		fwrite(redo,sizeof(redo),1,file);
		fwrite(&can_redo,sizeof(can_redo),1,file);
		fwrite(&redo_score,sizeof(redo_score),1,file);
		fwrite(&redo_count,sizeof(redo_count),1,file);
		_fcloseall();
	}
	else
		MessageBox(hwnd,TEXT("���ȱ���ʧ�ܡ�"),TEXT("��ʾ"),0);
}

LRESULT CALLBACK ChildWndProc (HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
	case WM_PAINT:
		HDC hdc;

		PAINTSTRUCT ps ;
		RECT rect;
		hdc = BeginPaint(hwnd, &ps);
		GetClientRect (hwnd, &rect);

		HDC hDCMem;
		HBITMAP hBitmap;
		hDCMem = CreateCompatibleDC(hdc);
		hBitmap = CreateCompatibleBitmap(hdc, rect.right - rect.left, rect.bottom - rect.top);
		SelectObject(hDCMem, hBitmap);

		FillRectAdvance(hDCMem,&rect,onmouse==GetDlgCtrlID(hwnd)?cr32:crGray);
		SetBkMode(hDCMem,TRANSPARENT);
		DrawTextAdvance(hDCMem,sButton[GetDlgCtrlID(hwnd)].Name,&rect,10,700,crWhite,FontName,DT_CENTER|DT_SINGLELINE|DT_VCENTER);

		BitBlt(hdc, 0, 0, rect.right - rect.left, rect.bottom - rect.top, hDCMem, 0, 0, SRCCOPY);
		DeleteObject(hBitmap);
		DeleteDC(hDCMem);

		EndPaint(hwnd, &ps);
		return 0 ;
	case WM_LBUTTONDOWN:
		switch (GetDlgCtrlID(hwnd))
		{
		case NEWGAME://����Ϸ
			if (AskStartNewGame()==true)
			{
				if (has_record_score==false)//û�м�¼�ɼ�
					if (InHighScore() && score>=HIGHSCORE_THRESHOLD)//����߷ְ񣬴���1000��
						JudgeFreshHighScore();//����ɼ���������ɼ��������а�Ȼ������
				Fill0(GetParent(hwnd));
			}
			break;
		case RANDOMGAME:
			if (redo_count>STEP_BEFORE_DEAD)
			{
				MessageBeep(0);
				if (MessageBox(GetParent(hwnd),TEXT("�Ƿ�������֣�\n������ʼ����Ϸ��"),TEXT("�������"),MB_YESNO|MB_ICONQUESTION)==IDNO)
					break;
			}
			score=0;
			Fill0(hwnd);
			onrandom=true;
			while (isDead()==false)
				SendMessage(GetParent(hwnd),WM_KEYDOWN,0x25+(rand() % 4),0);//�����4�������
			while (redo_count>(redo_num-1)-STEP_BEFORE_DEAD)//����ǰN��
			{
				Redo();
				redo_count--;
				step--;
			}
			step_after_random=0;
			redo_count=0;
			can_redo=0;
			FreshRedoButton();
			InvalidateRect(GetParent(hwnd),NULL,true);
			PlaySound((LPCTSTR)IDR_WAVE1,hInst,SND_RESOURCE|SND_ASYNC);
			onrandom=false;
			break;
		case REDO://����
			if (can_redo>0)
			{
				if (redo_count>0)
				{
					Redo();
					redo_count--;
					step--;
					step_after_random--;
					can_redo--;
					FreshRedoButton();
					InvalidateRect(GetParent(hwnd),NULL,true);
				}
			}
			break;
		case HIGHSCORE:
			MessageBeep(0);
			lstrcpy(szHighScore,TEXT("\t--- ���а� ---\n"));
			lstrcat(szHighScore,TEXT("\n ����    ����\t  �÷�"));
			for (int i=0;i<10;i++)
			{
				if (sHighScore[i].score!=0)
				{
					wsprintf(buffer_temp,TEXT("\n  %2d      %-10.10s\t  %-d��"),i+1,sHighScore[i].name,sHighScore[i].score);
					lstrcat(szHighScore,buffer_temp);
				}
				else
					break;
			}
			MessageBox(GetParent(hwnd),szHighScore,TEXT("���а�"),0);
			break;
		case README://˵��
			MessageBeep(0);
			DialogBox(hInst,TEXT("IDD_ABOUT"),hwnd,AboutDlgProc);
			break;
		}
		return 0;
	case WM_MOUSEMOVE:
		onmouse=GetDlgCtrlID(hwnd);
		for (int i=0;i<BNUM;i++)
			InvalidateRect(hwndButton[i],NULL,false);
		return 0;
	}
	return DefWindowProc (hwnd, message, wParam, lParam);
}

BOOL CALLBACK AboutDlgProc(HWND hDlg,UINT message,WPARAM wParam,LPARAM lParam)
{
	switch (message)
	{
	case WM_INITDIALOG:
		return TRUE;
	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg,0);
			return TRUE;
		}
		break;
	}
	return FALSE;
}

BOOL CALLBACK NameDlgProc(HWND hDlg,UINT message,WPARAM wParam,LPARAM lParam)
{
	switch (message)
	{
	case WM_INITDIALOG:
		PlaySound((LPCTSTR)IDR_CONGRATULATIONS,hInst,SND_RESOURCE|SND_ASYNC);//|SND_LOOP
		return TRUE;
	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			TCHAR szTemp[MAX_NAME_LENGTH];
			GetWindowText(GetDlgItem(hDlg,IDC_EDITNAME),szTemp,sizeof(szTemp));//�˴�Ӧ���޶����ֳ��ȣ���δ���
			if (lstrlen(szTemp)>0)
				FreshHighScore(szTemp);
			else
				FreshHighScore(TEXT("����"));
			EndDialog(hDlg,0);
			PlaySound(NULL,NULL,NULL);
			SendMessage(hwndButton[HIGHSCORE],WM_LBUTTONDOWN,0,0);
			return TRUE;
		case IDCANCEL:
			FreshHighScore(TEXT("����"));
			EndDialog(hDlg,0);
			PlaySound(NULL,NULL,NULL);
			SendMessage(hwndButton[HIGHSCORE],WM_LBUTTONDOWN,0,0);
			return TRUE;
		}
		break;
	}
	return FALSE;
}