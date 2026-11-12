//
// Created by Victor de Paula on 11/12/26.
//

#ifndef PROJECT3_VD_TEXTUREMANAGER_H
#define PROJECT3_VD_TEXTUREMANAGER_H

#pragma once
#include <unordered_map>
#include <SFML/Graphics.hpp>
#include <string>

class TextureManager {
    static unordered_map<string, sf::Texture> textures;

public:
    static sf::Texture& getTexture(string textureName);
};


#endif //PROJECT3_VD_TEXTUREMANAGER_H
