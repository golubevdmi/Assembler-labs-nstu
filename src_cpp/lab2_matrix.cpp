#include <Windows.h>

#include <iostream>
#include <conio.h>
#include <ctime>

bool initMat(std::uint32_t ***arr, const std::uint32_t& size);
std::double_t calcArithMean(std::uint32_t ***arr, const std::uint32_t& size);
void printMat(std::uint32_t ***arr, const std::uint32_t& size);

int main()
{
	std::double_t workTime = std::double_t(clock()) / 1000;

	

	std::uint32_t size = 10000;
	std::uint32_t **arr = nullptr;

	srand(time(NULL));

	//std::cout << "Enter a mat size: ";
	//std::cin >> size;

	initMat(&arr, size);
	//printMat(&arr, size);

	std::double_t arithMean = calcArithMean(&arr, size);
	//std::cout << "Arithmetic mean: " << arithMean << std::endl;

	for (std::uint32_t i = 0; i < size; i++)
	{
		delete[] arr[i];
	}
	delete arr;
	arr = nullptr;
	

	workTime = std::double_t(clock()) / 1000 - workTime;
	std::cout << "Working time " << ": " << workTime << std::endl;

	_getch();
	return 0;
}}

bool initMat(std::uint32_t ***arr, const std::uint32_t& size)
{
	if (size <= 0)	return false;

	(*arr) = new std::uint32_t *[size];

	for (std::uint32_t i = 0; i < size; i++)
	{
		(*arr)[i] = new std::uint32_t[size];

		for (std::uint32_t j = 0; j < size; j++)
		{
			(*arr)[i][j] = rand() % 100;
		}
	}


}
std::double_t calcArithMean(std::uint32_t ***arr, const std::uint32_t& size)
{
	std::uint32_t sumEl = 0;

	for (std::uint32_t j = 0; j < size; j++)
	{
		std::uint32_t maxEl = 0;

		for (std::uint32_t i = 0; i < size; i++)
		{
			if ((*arr)[i][j] > maxEl)
			{
				maxEl = (*arr)[i][j];
			}
		}

		sumEl += maxEl;
		maxEl = 0;
	}

	return std::double_t(sumEl) /  std::double_t(size);
}
void printMat(std::uint32_t ***arr, const std::uint32_t& size)
{
	std::cout << std::endl << "Print matrix: " << std::endl;
	for (std::uint32_t i = 0; i < size; i++)
	{
		std::cout << "[" << i << "] ";
		for (std::uint32_t j = 0; j < size; j++)
		{
			std::cout << (*arr)[i][j] << " ";
		}
		std::cout << std::endl;
	}

	std::cout << std::endl;
