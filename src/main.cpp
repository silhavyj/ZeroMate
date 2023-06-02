// ---------------------------------------------------------------------------------------------------------------------
/// \file main.cpp
/// \date 24. 05. 2023
/// \author Jakub Silhavy (jakub.silhavy.cz@gmail.com)
///
/// \brief This file defines and implements the main function of the application.
// ---------------------------------------------------------------------------------------------------------------------

// Project file imports

#include "gui/gui.hpp"

// ---------------------------------------------------------------------------------------------------------------------
/// \brief Entry point of the application.
/// \param argc Total number of arguments passed in from the command line
/// \param argv Arguments passed in from the command line
/// \return Exit code of the application
// ---------------------------------------------------------------------------------------------------------------------
int main(int argc, const char* argv[])
{
    return zero_mate::gui::Main_GUI(argc, argv);
}