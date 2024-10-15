Info<< "Reading field U\n" << endl;
volVectorField U
(
    IOobject
    (
        "U",
        runTime.timeName(),
        mesh,
        IOobject::MUST_READ,
        IOobject::AUTO_WRITE
    ),
    mesh
);

/*Info<< "Reading field UMean\n" << endl;
volVectorField UMean
(
    IOobject
    (
        "UMean",
        runTime.timeName(),
        mesh,
        IOobject::MUST_READ,
        IOobject::AUTO_WRITE
    ),
    mesh
);*/

Info<< "Reading field T\n" << endl;
volScalarField T
(
    IOobject
    (
        "T",
        runTime.timeName(),
        mesh,
        IOobject::MUST_READ,
        IOobject::AUTO_WRITE
    ),
    mesh
);

/*Info<< "Reading field TMean\n" << endl;
volScalarField TMean
(
    IOobject
    (
        "TMean",
        runTime.timeName(),
        mesh,
        IOobject::MUST_READ,
        IOobject::AUTO_WRITE
    ),
    mesh
);*/





Info<< "Reading transportProperties\n" << endl;
IOdictionary transportProperties
(
    IOobject
    (
        "transportProperties",
        runTime.constant(),
        mesh,
        IOobject::MUST_READ,
        IOobject::NO_WRITE
    )
);

//dimensionedScalar Twall (transportProperties.lookup("Twall"));
//dimensionedScalar Lc (transportProperties.lookup("Lc"));

dimensionedScalar Tbulk
(
    "Tbulk",
    dimensionSet(0, 0, 0, 1, 0, 0, 0),
    0.0
);

dimensionedScalar NuAvg
(
    "NuAvg",
    dimensionSet(0, 0, 0, 0, 0, 0, 0),
    0.0
);

fileName outputFile(runTime.path()/runTime.timeName()/"dTdn.csv");
OFstream outFile(outputFile);
