#pragma once
#include "welcomewindow.h"
#include <SFML/Graphics.hpp>
using namespace std;

int main()
{
	//opening config.cfg file, taking window size values, rendering window object
	ifstream 




	sf::RenderWindow window( sf::VideoMode( { 200, 200 } ), "SFML works!" );
	sf::CircleShape shape( 100.f );
	shape.setFillColor( sf::Color::Green );

	while ( window.isOpen() )
	{
		while ( const std::optional event = window.pollEvent() )
		{
			if ( event->is<sf::Event::Closed>() )
				window.close();
		}

		window.clear();
		window.draw( shape );
		window.display();
	}
}
