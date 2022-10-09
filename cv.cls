\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{freycv}[FreyCV]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
\newcommand{\cvsubsectionfont}{\large\bfseries}
%% v1.3: load hyperref for clickable hyperlinks
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
\ProcessOptions\relax

\LoadClass{extarticle}
%% v1.3.2 Hopefully this helps make the PDF
%% file more 'friendly' with copy-paste etc
\RequirePackage{etoolbox}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{accsupp}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}
\RequirePackage{xparse}

%% v1.1.5: added for convenience
\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\ifxetexorluatex
  \RequirePackage{fontspec}
\else
  %% v1.3.2 attempts to make ligatures
  %% copy-paste as normal characters
  \RequirePackage{cmap}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \input{glyphtounicode}
  \pdfglyphtounicode{f_f}{FB00}
  \pdfglyphtounicode{f_f_i}{FB03}
  \pdfglyphtounicode{f_f_l}{FB04}
  \pdfglyphtounicode{f_i}{FB01}
  \pdfgentounicode=1
\fi

\if@raggedtwoe
  \RequirePackage[newcommands]{ragged2e}
\fi

\if@withhyper
  \AtBeginDocument{%
    \hypersetup{hidelinks}
    \urlstyle{same}
  }
\fi

\RequirePackage{xcolor}

\colorlet{accent}{blue!70!black}
\colorlet{emphasis}{black}
\colorlet{heading}{black}
\colorlet{headingrule}{black}
\colorlet{subheading}{emphasis}
\colorlet{body}{black!80!white}
\colorlet{name}{heading}
\colorlet{tagline}{accent}
\newcommand{\itemmarker}{{\small\textbullet}}
\newcommand{\ratingmarker}{\faCircle}


\definecolor{NavyBlue}{HTML}{000080}
\definecolor{SlateGrey}{HTML}{2E2E2E}
\definecolor{LightGrey}{HTML}{666666}
\colorlet{name}{black}
\colorlet{tagline}{NavyBlue}
\colorlet{heading}{NavyBlue}
\colorlet{headingrule}{NavyBlue}
\colorlet{subheading}{NavyBlue}
\colorlet{accent}{NavyBlue}
\colorlet{emphasis}{SlateGrey}
\colorlet{body}{LightGrey}

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vspace{0.25\baselineskip}}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
% \RequirePackage{marginfix}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}

%% v1.3.1 \detokenize will break UTF-8 in pdflatex
%% Using alternative from https://tex.stackexchange.com/a/530911/226
\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
  \catcode`\_=12%
%   \catcode`\^=12%
%   \catcode`\{=12%
%   \catcode`\}=12%
  \catcode`\&=12%
  \catcode`\$=12%
  \catcode`\#=12%
  \catcode`\~=12%
%   \catcode`\\=12%
  {#1}%
}%
}
%% v1.3: Incorporating hyperlinks
%% v1.3.1: using \unfriendlydetokenize to avoid breaking unicode
%% v1.6: Use accsupp so that when copying/pasting the icon from PDF to a text
%%       file, the icon name is pasted
\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
  \BeginAccSupp{method=escape,ActualText={#1:~#2}}
  \IfNoValueTF{#3}{%
    \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
  }{%
     \if@withhyper%
      \mbox{\textcolor{accent}{\normalfont #1}~
      \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
     \else%
       \ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
      \mbox{\textcolor{accent}{\normalfont #1}~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
     \fi%
  }%
  \EndAccSupp{}
}%


%% v1.3: Exploring convenient creation of fields
%% v1.6: Add starred mode to create \printinfo with full URL
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanF{#1}{
    \IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
  }
  \csdef{#2 symbol}{#3}%
  \IfBooleanTF{#1}
    { \csdef{#2}##1##2{%
        \if@withhyper
          \IfNoValueTF {##2}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[##2]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
    { \csdef{#2}##1{%
        \if@withhyper
          \IfNoValueTF {#4}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
}
\ExplSyntaxOff

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{\faEnvelope}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{homepage}{\faLaptopCode}[http://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
\NewInfoField{linkedin}{\faLinkedin}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
\NewInfoField{location}{\faMapMarker}

% OLD
% \newcommand{\namefont}{\huge\bfseries}
\newcommand{\namefont}{\Huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\normalsize\bfseries}
\newcommand{\cvsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
  \begingroup
    % \altacv@left@photos\hfill%
    % \begin{minipage}{\dimexpr\linewidth-\altacv@photos@width}%
    % \raggedright%
    {\centering\namefont\color{name}\MakeUppercase{\@name}\par}
    \medskip
    {\centering\taglinefont\color{tagline}\@tagline\par}
    \medskip
    {\centering\personalinfofont\@personalinfo\par}
    % \end{minipage}\hfill%
    % \altacv@right@photos\par%
  \endgroup\medskip
}

\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

\newcommand{\cvsection}[2][]{%
  \nointerlineskip\bigskip%  %% bugfix in v1.6.2
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
  {\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
  {\color{headingrule}\rule{\linewidth}{1pt}\par}\medskip
}

%  OLD
% \newcommand{\cveducation}[4]{%
%   \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}\textbf{#1}}}}
%   \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\color{emphasis}\textbf{#2}}}}\par\smallskip
%   \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\faCalendar~#3}}}
%   \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][r]{\faClipboardCheck #4}}}\par
%   \medskip\normalsize
%   }

\newcommand{\cveducation}[4]{%
  \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}\textbf{#1}}}}
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\color{emphasis}\textbf{#2}}}}\par\smallskip
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\faClipboardCheck~#4}}}
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][r]{\faCalendar~#3}}}\par
  % \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][r]{\faClipboardCheck #4}}}\par
  \medskip\normalsize
  }

\newcommand{\cveducationcoming}[4]{%
  \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}\textbf{#1}}}}
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\color{emphasis}\textbf{#2}}}}\par\smallskip
  \ifstrequal{#4}{}{{\small\makebox[0.5\linewidth][l]{}}}{{\small\makebox[0.5\linewidth][l]{#4}}}
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][r]{\faCalendar~#3}}}\par
  \medskip\normalsize
  }

%  OLD
% \newcommand{\cvexperience}[5]{%
%   \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}\textbf{#1}}}}
%   \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{#2, \color{emphasis}\textbf{#4}}}}\par\smallskip
%   \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{#5}}}
%   \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\faCalendar~#3}}}\par
%   \medskip\normalsize
%   }


\newcommand{\cvexperience}[5]{%
  \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}\textbf{#1}}}}
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\color{emphasis} \textbf{#4}, #2}}}\par\smallskip
  \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{#5}}}
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\faCalendar~#3}}}\par
  \medskip\normalsize
  }

  \newcommand{\cvproject}[4]{%
  \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}#1}}}
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\color{emphasis}\textbf{#2}}}}\par\smallskip
  \ifstrequal{#3}{}{}{{\footnotesize\makebox[0.5\linewidth][l]{\faCode~#3}}}
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][r]{\faGithub #4}}}\par
  \medskip\normalsize
  }

  \newcommand{\cvpublication}[4]{%
  \ifstrequal{#1}{}{}{{\small\makebox[0.5\linewidth][l]{\color{emphasis}#1}}}
  \ifstrequal{#2}{}{}{{\small\makebox[0.5\linewidth][r]{\color{emphasis}\textbf{#2}}}}\par\smallskip
  \ifstrequal{#3}{}{}{{\footnotesize\makebox[0.5\linewidth][l]{\faCode~#3}}}
  \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][r]{\faBook #4}}}\par
  \medskip\normalsize
  }

\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

\newcommand{\addsidebar}[2][]{\marginpar{%
  \ifstrequal{#1}{}{}{\vspace*{#1}}%
  \input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

\AtBeginDocument{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}