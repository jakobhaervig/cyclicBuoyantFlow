outFile << "Time" << "," << "CoorX" << "," << "CoorY" << "," << "CoorZ" << "," << "dTdn" << "," << "dTdnAvg" << endl;

label inletID = mesh.boundaryMesh().findPatchID("bottom");
label wallID = mesh.boundaryMesh().findPatchID("walls"); //heated wall
//label wallID2 = mesh.boundaryMesh().findPatchID("adiWalltop_right"); //upper part of heated/adi wall

//const scalarField dTdn = T.boundaryField()[wallID].snGrad()*mesh.magSf().boundaryField()[wallID]/mesh.magSf().boundaryField()[wallID];
const scalarField dTdn = T.boundaryField()[wallID].snGrad();
const scalarField yPos = mesh.C().boundaryField()[wallID].component(1);
dimensionedScalar num
(
    "num",
    dimensionSet(0, 2, -1, 1, 0, 0, 0),
    gSum(T.boundaryField()[inletID]*U.boundaryField()[inletID].component(1)*mesh.magSf().boundaryField()[inletID])
);

dimensionedScalar den
(
    "den",
    dimensionSet(0, 2, -1, 0, 0, 0, 0),
    gSum(U.boundaryField()[inletID].component(1)*mesh.magSf().boundaryField()[inletID])
);

Tbulk=num/den;

dimensionedScalar dTdnAvg
(
    "dTdnAvg",
    dimensionSet(0, -1, 0, 1, 0, 0, 0),
    gSum(T.boundaryField()[wallID].snGrad()*mesh.magSf().boundaryField()[wallID])/gSum(mesh.magSf().boundaryField()[wallID])
);
//Info << dTdn << endl;
//Info << yPos << endl;
forAll(mesh.boundaryMesh()[wallID], i)
{

    //Info<< mesh.boundaryMesh()[wallID].faceCentres()[i] << endl;
    //Info<< dTdn[i] << endl;
    const vector coordinate = mesh.boundaryMesh()[wallID].faceCentres()[i];
    const scalar localNu = dTdn[i];

    outFile << runTime.timeName() << "," << coordinate.component(0) << "," << coordinate.component(1) << "," << coordinate.component(2) << "," << localNu << "," << dTdnAvg.value()  << endl;
    
}
/*
const scalarField dTdn2 = T.boundaryField()[wallID2].snGrad()*mesh.magSf().boundaryField()[wallID2]/mesh.magSf().boundaryField()[wallID2];

forAll(mesh.boundaryMesh()[wallID2], j)
{

    //Info<< mesh.boundaryMesh()[wallID].faceCentres()[i] << endl;
    //Info<< dTdn[i] << endl;
    const vector coordinate2 = mesh.boundaryMesh()[wallID2].faceCentres()[j];
    const scalar localNu2 = dTdn2[j];

    outFile << runTime.timeName() << "," << coordinate2.component(0) << "," << coordinate2.component(1) << "," << coordinate2.component(2) << "," << localNu2 <<  endl;
    
}
*/

//NuAvg = dTdnAvg*Lc/(Twall-Tbulk);
//Info<< "Average Nu = " << NuAvg.value() << endl;
