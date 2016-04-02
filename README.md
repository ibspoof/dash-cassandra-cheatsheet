## cassandra.yaml Cheatsheet for Dash

### Manual Installation

1. Generate Cheatsheet by using Ruby's cheatset function
```
sudo gem install cheatset
```
2. Convert to docset
```
cheatset generate cassandra.yaml.rb
```
3. Create cassandra folder in Dash folder
```
mkdir ~/Library/Application\ Support/Dash/Cheat\ Sheets/cassandra
```
4. Move docset to Dash folder
```
mv cassandra.docset ~/Library/Application\ Support/Dash/Cheat\ Sheets/cassandra/
```

### Quick Installation

```
wget https://github.com/ibspoof/dash-cassandra-cheatsheet/releases/download/v1.0.0/cassandra.zip && unzip cassandra.zip && mv cassandra ~/Library/Application\ Support/Dash/Cheat\ Sheets/
```
