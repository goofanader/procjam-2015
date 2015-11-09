# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [0.0.2] - 11/9/2015
### Added
- All three creatures start off at the beginning.
- Up to two body parts are added to a creature! Wao! It's totally random though and not well thought-out.

### Changed
- There's a force for x and y. It's only on the mouth body part, though.
- For creatures, the body variable is actually for a body, not what it currently is. Changed so that the initial starting "body" is called "mouth".
- bodyParts variable has a table of "body" and "shape". This is preliminary before switching over to the BodyPart class.
- Creature seed is based off the char bytes added together of the creature's name, index of its creation, and the current time.

### Removed
- The creatures don't fly anymore...

## 0.0.1 - 11/8/2015
Initial start.

### Added
- Gameboy color scheme as well as screen size of a Gameboy.
- The three starting body types: circle, square, and triangle.
- LOVE2D Physics engine and having the images match the rotation.
- Random choice of a starting body.
- Creature floats around randomly, according to a current-time-seed. ...It's actually kinda cute...

[Unreleased]: https://github.com/goofanader/procjam-2015/compare/v0.0.2-alpha...HEAD
[0.0.2]: https://github.com/goofanader/procjam-2015/compare/v0.0.1-alpha...v0.0.2-alpha
