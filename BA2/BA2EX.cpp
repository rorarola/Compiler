// 注意：噁心的競程寫法
#include <bits/stdc++.h>
using namespace std;

int main() {
	string in;
	map<char, set<char> > follow;
	map<char, set<char> > first;
	vector<string> grammar;
	while(getline(cin, in) && in != "END_OF_GRAMMAR") grammar.push_back(in);
	while(getline(cin, in) && in != "END_OF_FIRST_SET") 
		for(int i = 2; i < (int)in.length(); i++) first[in[0]].insert(in[i]);

	for(int i = 0; i < (int)first.size(); i++) {
		for(pair<char, set<char> > t : first) if(follow[t.first].empty()) {
			char nonterm = t.first;
			bool ok = true;
			set<char> tmp;
			for(string s : grammar) {
				for(int k = 2; k < (int)s.length(); k++) if(nonterm == s[k]) {
					int tot = k;
					while(isupper(s[++tot])) {
						tmp.insert(first[s[tot]].begin(), first[s[tot]].end());
						tmp.erase(';');
						if(first[s[tot]].count(';') == 0) break;
					}
					if(tot == s.length() || s[tot] == '|') {
						if(s[0] != nonterm && follow[s[0]].empty()) ok = false;
						tmp.insert(follow[s[0]].begin(), follow[s[0]].end());
					} else tmp.insert(s[tot]);
				}
			}
			if(tmp.empty()) tmp.insert('$');
			if(ok) follow[nonterm].insert(tmp.begin(), tmp.end());
		}
	}

	for(pair<char, set<char> > t : follow) {
		cout << t.first << ' ';
		for(char c : t.second) cout << c;
		cout << endl;
	}
}
