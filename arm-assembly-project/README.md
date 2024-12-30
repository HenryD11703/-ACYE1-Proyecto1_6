# ARM Assembly Project

## Overview
This project is an ARM assembly application that provides functionality for statistical analysis and data management. It includes a main program that presents a user menu, handles input, and calls utility functions for various tasks.

## Project Structure
```
arm-assembly-project
├── src
│   ├── programa.s    # Main assembly code for the application
│   └── utils.s       # Utility functions for data handling and statistics
├── Makefile          # Build instructions for the project
└── README.md         # Project documentation
```

## Files Description
- **src/programa.s**: Contains the main function and user interface for the application. It manages user interactions and invokes utility functions for tasks such as displaying team members and performing statistical analyses.

- **src/utils.s**: Provides utility functions that support the main program. This includes functions for loading data from CSV files, calculating statistical measures (mean, mode, max, min), and exporting results to a text file.

- **Makefile**: A script to compile the assembly code into an executable. It defines the rules for assembling the `.s` files and linking them together.

## Building the Project
To build the project, navigate to the project directory and run the following command:

```
make
```

This will assemble the source files and create the executable.

## Running the Application
After building the project, you can run the application using the following command:

```
./programa
```

Follow the on-screen menu to interact with the application and perform various tasks.

## Contributing
Feel free to contribute to this project by submitting issues or pull requests. Your feedback and contributions are welcome!