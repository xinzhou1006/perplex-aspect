#include <cmath>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <unistd.h>
#include "meemum_wrapper.h"

// secant method parameters
#define MAX_ITER 5
#define RTOL 0.00001

MeemumWrapper g_meemum;

double calc_dT(const double, const double, const double);

int main(int argc, char* argv[]) {
    const char *project_name { argv[1] };
    const double T0 = std::stod(argv[2]);
    const double p0 = std::stod(argv[3]);
    const double pN = std::stod(argv[4]);
    const size_t n_steps = std::stoi(argv[5]);

    const double dp = (pN - p0) / (n_steps - 1);



    std::ofstream myfile;
    myfile.open("mydata.csv");
    myfile << "p,T,S" << std::endl;
    myfile << std::setprecision(8) << std::fixed;

    g_meemum.init(project_name);
    double T = T0;
    double p = p0;

    for (p = p0 ; p < pN; p += dp) {
	// save composition information
        g_meemum.minimize(T, p);
	myfile << p << "," << T << "," 
	    << g_meemum.entropy() << std::endl;


	double dT = calc_dT(T, p, dp);
	T +=dT;

    }
    // save composition information
        g_meemum.minimize(T, p);
	myfile << p << "," << T << "," 
	    << g_meemum.entropy() << std::endl;

    myfile.close();
}

double calc_dT(const double T0, const double p0, const double dp) {
    g_meemum.minimize(T0, p0);
    // determine new temperature step
    const double S0 = g_meemum.entropy();

    double dT1 = 0;

    double alpha = g_meemum.expansivity();
    double Cp = g_meemum.heat_capacity();
    double rho = g_meemum.density();

    double dT2 = -alpha * T0 * dp *1e5 / Cp / rho;

    g_meemum.minimize(T0+dT1, p0+dp);
    double dS1 = g_meemum.entropy() - S0;

    for (size_t i = 0; i < MAX_ITER; i++) {
	g_meemum.minimize(T0+dT2, p0+dp);
	double dS2 = g_meemum.entropy() - S0;

	if (fabs(dS2 / S0) < RTOL)
	    return dT2;

	double dT3 = (dT1*dS2 - dT2*dS1) / (dS2 - dS1);


	// update values for next iteration
	dT1 = dT2;
	dT2 = dT3;

	dS1 = dS2;
    }
    throw;
}

