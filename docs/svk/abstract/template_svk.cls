% LaTeX Class - sablona pro SVK FAV
% 2012, Vladimir Lukes, Miroslav Byrtus

\ProvidesClass{template_svk}

\LoadClass[a4paper, 12pt]{article}
\RequirePackage[utf8]{inputenc}

% page geometry
\RequirePackage[a4paper,
  left=25mm, width =160mm,
  top =25mm, height=242mm]{geometry}

% AMSTeX
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{bm}
\RequirePackage{natbib}

% graphics
\RequirePackage{graphicx}

% fonts
\RequirePackage{times}
\RequirePackage{titlesec}
\titleformat{\section}{\large\bfseries}{\thesection}{0.5em}{}
\titleformat{\subsection}{\bfseries}{\thesubsection}{0.5em}{}

\RequirePackage{indentfirst}
\setlength{\parindent}{32pt}
\setlength{\parskip}{0pt}

\titlespacing{\section}{0pt}{15pt}{5pt}
\titlespacing{\subsection}{0pt}{15pt}{5pt}

\usepackage[splitrule]{footmisc} % hang
\addtolength{\footskip}{0cm}
\setlength{\footnotemargin}{2mm}
\setlength{\footnotesep}{0cm}

% no page numbering
\RequirePackage{nopageno}

% captions
\RequirePackage{caption}
\captionsetup{labelfont={bf}}

% header: title, authors, ...
\def\@titletext{\@latex@error{No title was provided}{}}
\def\@discardtok#1{}% token
\def\@increment#1{\advance #1 by 1\relax}% {\count}
\def\@name#1{\csname\expandafter\@discardtok\string#1\endcsname}% {\tokens}
\def\@withname#1#2{\expandafter#1\csname\expandafter\@discardtok\string#2\endcsname}% {\command}{\tokens}

\newcount{\@authorcount}
\newcount{\@authorindex}

\renewcommand{\title}[1]{%
  \gdef\@titletext{#1}
  \renewcommand{\refname}{{\large\bf \ifx\captionsczech\undefined References%
      \else Literatura\fi}}
}

\renewcommand{\author}[2] {
  \global\@increment\@authorcount
  \@withname\gdef{\@authorname\the\@authorcount}{#1}
  \@withname\gdef{\@authorinfo\the\@authorcount}{#2}
}

\def\@maketitle{%
  \begin{center}
    \vspace*{-47pt}
    \includegraphics[width=160mm]{SVK_zahlavi}\\
    \vspace{24pt}
    \noindent{\fontsize{16pt}{16pt}\selectfont\bf\@titletext}\par
    \ifcase\@authorcount
      \@latex@error{No authors were specified for this paper}{}\or
    \fi
    \global\@authorindex=0
    \vspace{18pt}
    \noindent{\@authorloop}\par
    \vspace{4pt}
  \end{center}
}

\def\@authorloop{%
  \relax\ifnum\@authorindex<\@authorcount\@increment{\@authorindex}
    \@setauthor{\the\@authorindex}
    \ifnum\@authorindex<\@authorcount, \unskip\fi\@authorloop
  \fi
}

\def\@setauthor#1 {
  \renewcommand{\thefootnote}{\arabic{footnote}}
  \mbox{\@name{\@authorname#1}}\footnote{\,\@name{\@authorinfo#1}}
}

% references
\makeatletter
\renewcommand{\@openbib@code}{% Reduce vertical gap between bibitems
  \advance\leftmargin \z@%
  \itemindent \z@%
  \parsep -0.8ex}
\makeatother

% acknowledgement
\newcommand{\acknowledgement}[1]{
  \vspace{15pt}
  \noindent{\bf \ifx\captionsczech\undefined Acknowledgement\else Poděkování\fi}\par
  \vspace{6pt}#1
}
