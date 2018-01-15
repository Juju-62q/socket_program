import pygame
from pygame.locals import Rect

class Player:

    def __init__(self, x, y, width, height, normalImage, killerWidth, killerImage, move):
        self._rect = Rect(x, y, width, height)
        self._normalImage = normalImage
        self._killerRect = (x + width, y, killerWidth, height)
        self._killerImage = killerImage
        self._killerFlag = False
        self._killerCount = 0
        self._move = move

    @property
    def rect(self):
        return self._rect

    @rect.setter
    def rect(self, rect):
        self._rect = rect

    @property
    def killerRect(self):
        return self._killerRect

    @killerRect.setter
    def killerRect(self, killerRect):
        self._killerRect = killerRect

    @property
    def killerFlag(self):
        return self._killerFlag

    @killerFlag.setter
    def killerFlag(self, killerFlag):
        self._killerFlag = killerFlag

    @property
    def killerCount(self):
        return self._killerCount

    @killerCount.setter
    def killerCount(self, killerCount):
        self._killerCount = killerCount

    @property
    def move(self):
        return self._move

    @move.setter
    def move(self, move):
        self._move = move

    def getImage(self):
        return self._killerImage if self.killerFlag else self._normalImage

    def movePlayer(self, pressedKey, fieldWidth, fieldAbove, fieldBottom):
        if pressedKey[pygame.K_UP]:
            self.rect.y -= self.move if self.rect.y > fieldAbove else 0
        elif pressedKey[pygame.K_DOWN]:
            self.rect.y += self.move if self.rect.y < fieldBottom - self.rect.height else 0
        if pressedKey[pygame.K_RIGHT]:
            self.rect.x += self.move if self.rect.x < fieldWidth - self.rect.width else 0
        elif pressedKey[pygame.K_LEFT]:
            self.rect.x -= self.move if self.rect.x > 0 else 0

    def updatePlayerImage(self, pressedKey):
        if self.killerFlag:
            self.killerCount += 1
        elif pressedKey[pygame.K_z]:
            self.killerCount = 0
            self.killerFlag = True
        if self.killerCount > 100:
            self.killerFlag = False