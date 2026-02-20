--
-- PostgreSQL database dump (Sanitized for Local Docker Usage)
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

SET default_tablespace = '';
SET default_table_access_method = heap;

-- 1. TABLE DEFINITIONS
CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(100),
    description text,
    isbn character varying(20),
    personal_rating numeric(3,1),
    author_name character varying(100)
);

CREATE SEQUENCE public.books_id_seq
    AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;

CREATE TABLE public.comments (
    id integer NOT NULL,
    comment text,
    user_id uuid,
    book_id integer
);

CREATE SEQUENCE public.comments_id_seq
    AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;

CREATE TABLE public.notes (
    id integer NOT NULL,
    notes text,
    book_id integer,
    display_order integer DEFAULT 0
);

CREATE SEQUENCE public.notes_id_seq
    AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    password text NOT NULL,
    image_url text DEFAULT 'https://cdn-icons-png.flaticon.com/512/147/147144.png'::text,
    fname text,
    lname text
);

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);
ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);
ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);

-- 2. DATA INSERTION (SEEDING)

COPY public.books (id, title, description, isbn, personal_rating, author_name) FROM stdin;
2	Feel Good Productivity	Being productive doesn't always have to suck. Sometimes, you just have to find the fun in it.	1847943748	9.3	Ali Abdaal
1	Never Split the difference	A guide to negotiation. Written by a hostage negotiator, so it's gotta be right, right?	9780062407801	9.2	Chris Voss
9	The Millionaire FASTLANE	Tired of trading time for money? Me too.	0984358102	9.2	MJ DeMarco
4	The Subtle Art of Not Giving a F*ck	Get your priorities straight. Not everyone deserves your attention. Stop caring about what others' think, they are useless anyways.	0062457713	8.7	Mark Manson
3	Atomic Habits	The power of compounding applies to habits too. Tiny changes, remarkable results. Focus on processes & systems, not the end result!	0735211299	9.0	James Clear
5	How to Win Friends and Influence People	Dealing with people is difficult. But this book is one that anyone should read.	0671027034	9.0	Dale Carnegie
6	Why We Sleep	Still can't cure my insomnia. But a very fascinating one nonetheless.	9781501144325	8.2	Matthew Walker
7	The Psychology of Money	Wealth is what you don't see. Stop spending like crazy and save your money for something better.	0857197681	8.5	Morgan Housel
8	Surrounded by Idiots	So people can be divided into colors. Know their colors and learn how to deal with them.	1250179947	8.8	Thomas Eriksen
10	Deep Work	Deep work = uninterrupted periods of hyper-focus. Unless you're Buddha, you're probably not here yet.	1455586692	8.6	Cal Newport
12	48 Laws of Power	How to be a manipulating psycho.	0140280197	6.1	Robert Greene
11	Models	How to not be a pain in the ass in a relationship and how to avoid potential partners that are a pain in the ass.	 1463750358	9.0	Mark Manson
13	Can't Hurt Me	Am I a masochist? I'm not even sure anymore.	1544512287	9.0	David Goggins
14	Ikigai: The Japanese Secret to a Long and Happy Life	I want to live in a chill Japanese village	0143130722	8.4	Héctor García, Francesc Miralles  
15	Zen Wisdom for the Anxious: Simple Advice from a Zen Buddhist Monk	-	4805315733	0.0	Shinsuke Hosokawa
16	DotCom Secrets: The Underground Playbook for Growing Your Company Online	-	1630474770	0.0	Russell Brunson
17	Flow: The Psychology of Optimal Experience	-	0061339202	0.0	Mihaly Csikszentmihalyi
\.

COPY public.comments (id, comment, user_id, book_id) FROM stdin;
5	very good	00000000-0000-0000-0000-000000000001	2
\.

COPY public.notes (id, notes, book_id, display_order) FROM stdin;
174	- Money is a tool, not the end goal.	9	49
176	- Don’t depend solely on investments; use them to protect, not create, wealth.	9	51
180	- Your job can’t make you rich — ownership can.	9	55
2	→ What the book is about	2	1
5	→ Key Frameworks / Models	2	7
38	 	2	8
39	 	2	12
40	 	2	16
181	- Speed matters: start young, act fast, and learn quickly.	9	56
44	→ Core Idea	1	1
45	 	1	2
47	• Argues that negotiation is not about logic or compromise, but about emotional intelligence, empathy, and tactical communication.	1	4
49	 	1	6
50	 	1	7
53	 	1	9
54	1. Mirroring	1	10
56	• Repeat the last few words your counterpart says (in a calm tone).	1	12
58	• Example:	1	14
60	⇾ You: “Not sure this will work?”	1	16
62	 	1	18
63	2. Labeling	1	19
67	• Use phrases like “It seems like…”, “It looks like…”, “It sounds like…”.	1	22
69	 	1	24
70	3. Tactical Empathy	1	25
72	• Makes people feel heard — and once they feel understood, they become more flexible.	1	27
73	 	1	28
76	 	1	30
77	• Encourage the other person to say no, because it makes them feel safe and in control.	1	31
79	• Example: “Would it be ridiculous to consider…?” invites a safe “No.”	1	33
4	When we feel positive emotions, it boosts our energy, creativity, and resilience; the book presents a model built on that insight. 	2	4
182	- Education is valuable, but execution beats knowledge.	9	57
6	• Three Energisers — what increases your energy & motivation:	2	8
7	1. Play — injecting fun, adventure, novelty into tasks.	2	9
8	2. Power — feeling confident, having autonomy, owning what you can.	2	10
9	3. People — social connections, helping others, community.	2	11
10	• Three Blockers — what tends to stall productivity:	2	12
11	1. Uncertainty — not knowing what to do, why, or when.	2	13
81	 	1	35
84	• Ask “How” and “What” questions to shift problem-solving to them.	1	38
86	⇾ “How am I supposed to do that?”	1	40
88	• This invites collaboration instead of confrontation.	1	42
90	6. The “Ackerman Model” (Bargaining Framework)	1	44
92	1. Set your target price (goal).  	1	46
94	3. Increase to 85%, then 95%, then 100%, using empathy and calibrated questions.	1	48
96	 	1	50
97	7. The 7-38-55 Rule of Communication	1	51
99	• Emotional delivery matters more than exact wording.	1	53
100	 	1	54
101	8. “That’s Right” Moment	1	55
102	 	1	56
104	• “That’s right” shows genuine agreement and understanding.	1	58
107	 	1	61
109	• Every negotiation has unknowns — discovering them gives you leverage.	1	63
111	 	1	65
112	→ Mindset Shifts	1	66
113	 	1	67
118	 	1	72
3	Rather than pushing through via discipline and “hustle”, productivity works better when it’s tied to feeling good.	2	3
119	 	1	73
125	💡 Core Concept	9	1
127	 	9	2
128	- Most people follow the “Slow Lane” — trading time for money, saving for decades, and hoping to retire rich.	9	3
130	- True wealth = freedom + control over time, not just money.	9	5
131	 	9	6
132	 	9	7
136	- Lives paycheck to paycheck.	9	11
138	- No financial discipline; blames others for money problems.	9	13
139	 	9	14
141	- Works hard, saves money, invests in mutual funds.	9	16
143	- Controlled by employers, the economy, and time — too slow.	9	18
145	3. The Fastlane (Entrepreneurial Path)	9	20
150	 	9	25
151	🚀 The Fastlane Formula	9	26
152	Wealth = Net Profit + Asset Value	9	27
153	- Instead of saving for decades, create something that provides value to many people.	9	28
154	- Scale your impact — the more value you give, the more money you can make.	9	29
155	 	9	30
156	 	9	31
157	⚙️ Five Fastlane Commandments (CENTS Framework)	9	32
159	2. Entry – The harder it is to enter, the more profitable it can be (high barriers = low competition).	9	34
165	💭 Mindset Shifts	9	40
167	- Stop trading time for money — it limits your growth.	9	42
168	- Wealth isn’t about frugality; it’s about value and leverage.	9	43
169	- Millionaires don’t rely on luck — they build systems.	9	44
170	- Money is a byproduct of solving problems at scale.	9	45
171	 	9	46
172	 	9	47
183	- Focus on impact — money follows value.	9	58
187	- The Fastlane is about building scalable value-driven systems.	9	62
190	- Wealth isn’t a distant dream; it’s a strategic choice and consistent action.	9	65
191	🧠 Core Idea	5	1
192	- Success in life and business depends more on how well you deal with people than on technical knowledge or intelligence.	5	2
193	- Treating others with respect, empathy, and genuine interest leads to influence and cooperation.	5	3
194	 	5	4
195	 	5	5
196	🗣️ Part 1: Fundamental Techniques in Handling People	5	6
200	 	5	10
201	 	5	11
34	 	2	2
20	 	2	23
21	• Use “five-minute rule”: commit to doing a task for 5 minutes to get past inertia.	2	24
22	• Clarify why, what, when for projects or tasks to reduce uncertainty.	2	25
23	• Set goals that are NICE: Near-term, Input-based, Controllable, Energizing.	2	26
24	• Reframe failures as experiments; lower stakes when possible.	2	27
25	• Use social support: ask for help, share your progress, cultivate “comrade mindset”.	2	28
26	 	2	29
27	 	2	30
129	- MJ DeMarco argues you can achieve wealth much faster by taking the “Fastlane” — building scalable systems, businesses, or assets that grow beyond your time.	9	4
29	• Book defines three types of burnout: overexertion (taking on too much), depletion (not resting well), misalignment (doing work that doesn’t align with values)	2	32
30	• To avoid burnout, you need to:	2	33
31	1. Say no to non-essential things. 	2	34
32	2. Take quality rest and breaks.	2	35
33	3. Regularly reflect on values & adjust your priorities.	2	36
43	 	2	21
19	→ Concrete Tips & Experiments	2	22
28	→ Burnout / Sustainability	2	31
46	• Written by former FBI hostage negotiator Chris Voss.	1	3
48	• “Never split the difference” means: don’t settle halfway — aim for outcomes that truly satisfy your goals.	1	5
51	→ Key Principles & Techniques	1	8
55	 	1	11
57	• Builds rapport and encourages them to elaborate.	1	13
36	 	2	5
12	2. Fear — fear of failure, fear of judgment, etc.	2	14
13	3. Inertia — difficulty starting, getting stuck before doing anything.	2	15
14	• Three Sustainers — how to maintain productivity without burning out:	2	16
15	1. Conserve — doing less of what’s non essential; setting boundaries.	2	17
16	2. Recharge — rest, breaks, creative or nature-based or passive rest. 	2	18
17	3. Align — making sure what you do aligns with your values & meaning. 	2	19
18	 	2	20
133	🛣️ The Three Financial Roads	9	8
134	 	9	9
135	1. The Sidewalk (Broke Mindset)	9	10
137	- Focuses on spending and lifestyle, not creating value.	9	12
140	2. The Slowlane (Traditional Path)	9	15
142	- Relies on compound interest and retirement at 65+.	9	17
144	 	9	19
146	- Builds a business, system, or brand that earns money independently.	9	21
147	- Leverages time, people, and processes.	9	22
148	- Prioritizes value creation, not hours worked.	9	23
149	 	9	24
158	1. Control – You must control your business (don’t depend on others like franchises or MLMs). 	9	33
160	3. Need – Solve real problems and fulfill real needs (not just passion projects).	9	35
161	4. Time – Detach your income from your time; build systems that make money while you sleep.	9	36
37	 	2	6
59	⇾ Them: “I’m not sure this will work.”	1	15
61	Basically, be a broken record	1	17
65	 	1	20
66	• Identify and name the other person’s emotions to diffuse tension.	1	21
68	• Example: “It seems like you’re frustrated with the process.”	1	23
71	• Understand and verbalize what the other side feels and sees.	1	26
74	4. The Power of “No”	1	29
78	• “No” opens real discussion; “Yes” is often fake or forced.	1	32
80	Here, you can combine this with labeling. Exaggerate the situation so much that the opponent says no. Force a no.	1	34
82	5. Calibrated (Open-Ended) Questions	1	36
83	 	1	37
85	• Example:	1	39
87	⇾ “What would it take to make this work for you?”	1	41
89	 	1	43
91	 	1	45
93	2. Start at 65% of that number.	1	47
95	4. End with a non-monetary item to show you’re at your limit.	1	49
98	• Only 7% of meaning is in words; 38% in tone; 55% in body language.	1	52
103	• Your goal is to get the other person to say “That’s right”, not “You’re right.”	1	57
105	 	1	59
106	9. The “Black Swan” Concept	1	60
108	• Look for hidden pieces of information (“Black Swans”) that can change the whole negotiation.	1	62
110	 	1	64
114	Negotiation is not war, it’s discovery.	1	68
115	Empathy is not weakness; it’s a powerful tool.	1	69
116	Patience and listening are more effective than pushing.	1	70
117	Never compromise just to “meet in the middle” — that often means both sides lose.	1	71
120	→ Key Takeaways	1	74
121	 	1	75
122	Good negotiators create trust through empathy, not dominance.	1	76
123	Use tone, curiosity, and emotional intelligence to influence outcomes.	1	77
124	The best deals come from connection, not competition.	1	78
162	5. Scale – Choose models that can reach many people (e.g., online products, apps, media, etc.).	9	37
163	 	9	38
164	 	9	39
173	💸 The Role of Money	9	48
175	- Use it to buy freedom and time, not just things.	9	50
177	 	9	52
178	 	9	53
179	🧠 DeMarco’s Key Lessons	9	54
184	 	9	59
185	 	9	60
186	🏁 Final Takeaways	9	61
188	- Don’t “live below your means” — expand your means.	9	63
189	- Freedom > Security — use your time to create assets, not just income.	9	64
197	- Don’t criticize, condemn, or complain. Criticism only makes people defensive.	5	7
198	- Give honest and sincere appreciation. Everyone craves recognition.	5	8
199	- Arouse in the other person an eager want. Show how they’ll benefit from your idea.	5	9
202	🤝 Part 2: Six Ways to Make People Like You	5	12
203	- Become genuinely interested in other people.	5	13
204	- Smile. It’s simple but powerful.	5	14
205	- Remember that a person’s name is the sweetest sound to them.	5	15
206	- Be a good listener. Encourage others to talk about themselves.	5	16
207	- Talk in terms of the other person’s interests.	5	17
208	- Make the other person feel important—and do it sincerely.	5	18
209	 	5	19
210	 	5	20
211	💬 Part 3: How to Win People to Your Way of Thinking	5	21
212	- Avoid arguments. You can’t win them.	5	22
213	- Show respect for the other person’s opinions. Never say “You’re wrong.”	5	23
214	- If you’re wrong, admit it quickly and emphatically.	5	24
215	- Begin in a friendly way.	5	25
216	- Get the other person saying “yes, yes” immediately.	5	26
217	- Let the other person do most of the talking.	5	27
218	- Let them feel that the idea is theirs.	5	28
219	- Try honestly to see things from their point of view.	5	29
220	- Be sympathetic with their ideas and desires.	5	30
221	- Appeal to nobler motives.	5	31
222	- Dramatize your ideas.	5	32
223	- Throw down a challenge to inspire action or competition.	5	33
225	 	5	34
226	 	5	35
227	👥 Part 4: Be a Leader – How to Change People Without Giving Offense or Arousing Resentment	5	36
228	- Begin with praise and honest appreciation.	5	37
229	- Call attention to people’s mistakes indirectly.	5	38
230	- Talk about your own mistakes before criticizing others.	5	39
231	- Ask questions instead of giving direct orders.	5	40
232	- Let the other person save face.	5	41
233	- Praise small improvements and every improvement.	5	42
234	- Give the other person a fine reputation to live up to.	5	43
235	- Use encouragement. Make the fault seem easy to correct.	5	44
236	- Make the other person happy about doing what you suggest.	5	45
237	🧠 Core Idea	3	1
238	- Small, consistent habits lead to remarkable long-term results.	3	2
239	- Focus on systems and identity rather than just goals.	3	3
240	- Habits compound over time — small improvements build exponentially, and small negative habits also compound.	3	4
241	- Success is the product of daily routines, not rare events or sudden breakthroughs.	3	5
242	 	3	6
243	 	3	7
244	⚙️ The Four Laws of Behavior Change	3	8
245	1️⃣ Make It Obvious (Cue)	3	9
246	- Habits start with cues — signals in your environment that trigger behavior.	3	10
247	Strategies:	3	11
249	- Example: “After I pour my morning coffee, I will meditate for 2 minutes.”	3	13
250	Implementation intentions: specify exact time and place for habits.	3	14
248	Habit stacking: link a new habit to an existing one.	3	12
251	- Example: “I will exercise at 7 AM in my living room.”	3	15
252	Environment design: make cues for good habits visible, hide cues for bad habits.	3	16
253	 	3	17
254	2️⃣ Make It Attractive (Craving)	3	18
255	- People repeat behaviors they look forward to.	3	19
256	Make habits more appealing:	3	20
258	- Example: “Only watch Netflix while I’m on the treadmill.”	3	22
278	- Example: “I am a healthy person” → encourages eating healthy automatically.	3	42
259	Reframe habits positively: focus on benefits, not pain.	3	23
257	=> Temptation bundling: pair a habit with something you enjoy.	3	21
260	=> Social influence: surround yourself with people who model the habits you want.	3	24
261	 	3	25
262	3️⃣ Make It Easy (Response)	3	26
263	=> Reduce friction for good habits; increase friction for bad ones.	3	27
264	=> Use the Two-Minute Rule: any new habit should take less than 2 minutes to start.	3	28
265	- Example: instead of “read 50 pages a day,” start with “read one page.”	3	29
266	=> Automate behaviors when possible (apps, reminders, prep materials).	3	30
267	=> Focus on showing up consistently, not on intensity or perfection.	3	31
268	 	3	32
269	4️⃣ Make It Satisfying (Reward)	3	33
270	=> Immediate rewards help reinforce habits.	3	34
271	=> Use tracking systems to visualize progress (habit trackers, checklists).	3	35
272	=> Create temptations or small wins that feel satisfying.	3	36
273	=> Make bad habits unsatisfying or costly to reduce repetition.	3	37
274	 	3	38
275	 	3	39
276	💡 Identity-Based Habits	3	40
277	=> Focus on who you want to become, not just what you want to achieve.	3	41
279	=> Habits reinforce identity; identity reinforces habits.	3	43
280	=> Ask: “What kind of person would do this habit?” instead of “What do I want to achieve?”	3	44
281	 	3	45
282	 	3	46
283	🏗️ Systems Over Goals	3	47
284	- Goals are about outcomes; systems are about processes and behaviors.	3	48
285	- Winners and successful people focus on building and optimizing systems.	3	49
286	- Systems allow continuous improvement and long-term growth.	3	50
287	 	3	51
288	 	3	52
289	⏳ The Power of Compounding	3	53
480	=> Monastic (cut off all distractions completely).	10	34
290	- Tiny improvements (1% better every day) lead to massive gains over time.	3	54
291	- Similarly, small negative habits compound into major problems.	3	55
483	=> Journalistic (fit deep work wherever possible).	10	37
292	- Habits shape your trajectory more than talent, luck, or willpower.	3	56
293	 	3	57
294	 	3	58
296	🌳 Environment Shapes Behavior	3	59
297	=> Your surroundings influence your actions more than motivation alone.	3	60
298	Strategies:	3	61
299	- Make cues for good habits obvious and convenient.	3	62
300	- Remove cues for bad habits.	3	63
301	- Align your environment with your desired identity.	3	64
302	Example: leave workout clothes out to trigger exercise; hide junk food to prevent snacking.	3	65
303	 	3	66
304	 	3	67
305	🔄 Advanced Concepts	3	68
306	Habit inversion: to break a bad habit, invert the 4 laws:	3	69
308	1. Make it invisible	3	71
309	2. Make it unattractive	3	72
310	3. Make it difficult	3	73
311	4. Make it unsatisfying	3	74
312	Habit shaping: start with very small habits, gradually increase difficulty or intensity.	3	75
313	Goldilocks rule: work on habits that are challenging but achievable to maintain engagement.	3	76
314	 	3	77
315	 	3	78
316	🧠 Mindset Shifts	3	79
317	=> Focus on identity and systems, not motivation or willpower.	3	80
318	=> Forget “big goals” — consistency beats intensity.	3	81
319	=> Use tracking, cues, and rewards to automate habits.	3	82
320	=> Be patient — habits are long-term investments, not instant fixes.	3	83
321	 	3	84
322	 	3	85
323	🏁 Key Takeaways	3	86
324	=> Small changes compound into big results.	3	87
325	=> Environment and cues are as important as effort.	3	88
326	=> Track your progress to make habits satisfying.	3	89
327	=> Start tiny, scale gradually, and focus on the person you want to become.	3	90
328	Systems > Goals; Identity > Outcomes.	3	91
329	🧠 Core Idea	11	1
330	• Attraction is built on honesty, authenticity, and emotional health, not manipulative “pickup” tactics.	11	2
331	• The book focuses on becoming the best version of yourself to naturally attract the right partners.	11	3
332	• Confidence comes from being honest with yourself and others, not from ego or games.	11	4
333	 	11	5
334	 	11	6
335	💡 Key Concepts	11	7
336	1️⃣ Vulnerability is Attractive	11	8
337	-> Being willing to show your true self, including flaws and desires, creates trust.	11	9
338	-> Emotional openness signals maturity and confidence.	11	10
339	 	11	11
340	2️⃣ Honesty Over Game	11	12
341	-> Stop using manipulative tactics or “tricks” to attract women.	11	13
342	-> Authenticity and direct communication are far more effective.	11	14
343	-> “Honest game” > fake confidence.	11	15
344	 	11	16
345	3️⃣ Emotional Health Matters	11	17
346	-> Work on your insecurities, anxieties, and self-worth before seeking relationships.	11	18
347	-> Women are attracted to men who are emotionally stable and self-aware.	11	19
348	 	11	20
349	4️⃣ Attraction Comes from Lifestyle	11	21
350	-> Being interesting and attractive isn’t just looks — it’s your life, goals, and passions.	11	22
351	-> Focus on hobbies, career, social connections, and personal growth.	11	23
352	 	11	24
353	5️⃣ Social Proof & Confidence	11	25
354	-> Confidence is a byproduct of living a meaningful life, not pretending.	11	26
355	-> Surround yourself with supportive friends, pursue meaningful goals, and improve social skills naturally.	11	27
356	 	11	28
357	6️⃣ The Importance of Boundaries	11	29
358	-> Don’t compromise your values or self-respect to please others.	11	30
359	-> Set limits and communicate them clearly.	11	31
360	 	11	32
361	7️⃣ Rejection is a Tool	11	33
362	-> Accept that rejection is natural and necessary.	11	34
363	-> Learn from it, and don’t let fear dictate your actions.	11	35
364	 	11	36
365	8️⃣ Mindset Over Techniques	11	37
366	-> Success in dating and life comes from inner growth, not memorized routines.	11	38
367	-> Focus on being a high-value person, not on “closing techniques.”	11	39
368	 	11	40
369	 	11	41
370	🏗️ Practical Advice / Applications	11	42
371	•  Improve yourself physically, mentally, socially, and emotionally.	11	43
372	• Be honest about your intentions and desires.	11	44
373	• Engage women through genuine conversation, curiosity, and humor.	11	45
374	• Take care of your lifestyle: health, work, hobbies, friendships.	11	46
375	• Practice social courage — speak your mind respectfully, handle rejection gracefully.	11	47
376	 	11	48
377	 	11	49
378	🏁 Takeaways	11	50
379	• Authenticity beats manipulation.	11	51
380	• Work on yourself first; attraction follows naturally.	11	52
381	• Emotional honesty, vulnerability, and confidence are core to relationships.	11	53
382	• Boundaries and integrity matter more than temporary success or tricks.	11	54
383	• Build a fulfilling life, and women will be drawn to it organically.	11	55
384	🧠 Core Idea	4	1
385	- Life is limited, and so is your time and energy — so choose carefully what to care about.	4	2
386	- Happiness comes not from avoiding problems, but from choosing meaningful problems to solve.	4	3
387	- “Not giving a f***” doesn’t mean being indifferent; it means being selective about your values.	4	4
388	 	4	5
389	 	4	6
390	💡 Key Concepts	4	7
391	1️⃣ Choose What to Give a F*** About	4	8
392	- You can’t care about everything — most things don’t matter.	4	9
393	- Focus your attention on what truly aligns with your values and purpose.	4	10
394	- Stop wasting energy trying to please everyone.	4	11
395	 	4	12
396	2️⃣ Life is Full of Problems	4	13
397	- Happiness is found in solving problems, not in having no problems.	4	14
398	- Choose problems you enjoy working on.	4	15
399	- Avoiding struggle leads to emptiness, not peace.	4	16
400	 	4	17
401	3️⃣ Responsibility Over Blame	4	18
402	- Take full responsibility for your choices and reactions.	4	19
403	- Even when things aren’t your fault, how you respond is still your responsibility.	4	20
404	- Freedom comes from owning your decisions.	4	21
405	 	4	22
406	4️⃣ You Are Not Special	4	23
407	- Modern culture glorifies constant positivity and uniqueness.	4	24
408	- Accepting your ordinariness brings humility and peace.	4	25
409	- Growth starts when you stop needing to be extraordinary.	4	26
410		4	27
412	5️⃣ The Value of Suffering	4	28
413	- What you’re willing to suffer for defines what you truly value.	4	29
414	Example: If you want to be fit, you must accept the pain of working out.	4	30
415	- Real happiness comes from meaningful struggle.	4	31
416	 	4	32
417	6️⃣ Certainty is the Enemy	4	33
418	- Embrace doubt and uncertainty — being wrong is how you learn.	4	34
419	- People who are always “sure” often stay stuck in their beliefs.	4	35
420	- True confidence is being comfortable with not knowing everything.	4	36
421		4	37
422	7️⃣ Rejection and Boundaries	4	38
423	- Saying “no” is essential for living authentically.	4	39
424	- Rejection helps define your boundaries and values.	4	40
425	- Don’t fear rejection; it’s part of being honest and selective.	4	41
426		4	42
427	8️⃣ Death Gives Life Meaning	4	43
428	- Remembering death helps clarify what truly matters.	4	44
429	- When you face your mortality, you start living with intention.	4	45
430	- “You will die someday” — so stop wasting your limited f***s.	4	46
431		4	47
432		4	48
433	🧩 Mindset Shifts	4	49
434	- Stop chasing constant happiness — it’s impossible.	4	50
435	- Failure, pain, and discomfort are necessary for growth.	4	51
436	- Care deeply about fewer things that truly align with your values.	4	52
437	- True freedom = caring less about external approval and more about personal meaning.	4	53
438		4	54
439		4	55
440	🏁 Key Takeaways	4	56
441	- Life is short; don’t waste it on meaningless worries.	4	57
443	- Happiness = solving meaningful problems, not avoiding them.	4	58
444	- Responsibility > Blame.	4	59
445	- You grow by accepting pain, uncertainty, and rejection.	4	60
446	- Death gives urgency — live intentionally.	4	61
447	🧠 Core Idea	10	1
448	- Deep work = focused, distraction-free work that pushes your cognitive limits.	10	2
449	- It’s how you create high-value output and develop meaningful skills.	10	3
450	- In contrast, shallow work = easy, logistical, or repetitive tasks that don’t require deep focus.	10	4
451	- In today’s world of distractions, deep work is a superpower for success.	10	5
452		10	6
453		10	7
454	💡 Why Deep Work Matters	10	8
455	- Modern workers are constantly distracted by notifications, emails, and multitasking.	10	9
456	- Shallow work dominates most people’s schedules, leaving little room for real progress.	10	10
457	Deep work allows you to:	10	11
458	=> Learn faster and build rare skills.	10	12
459	=> Produce higher-quality results in less time.	10	13
460	=> Feel greater satisfaction and purpose.	10	14
461		10	15
462		10	16
463	⚙️ The Two Core Principles	10	17
464	1️⃣ Deep Work Is Valuable	10	18
465	- In the information age, those who can focus deeply thrive.	10	19
466	- High-quality work = time spent × intensity of focus.	10	20
467	- The ability to focus intensely is rare but crucial.	10	21
468	 	10	22
469	2️⃣ Deep Work Is Meaningful	10	23
470	- Deep focus gives work a sense of craftsmanship and pride.	10	24
471	- It helps you connect with your purpose and reach “flow” states.	10	25
472		10	26
473		10	27
474	🧭 The Four Rules of Deep Work	10	28
475	Rule #1: Work Deeply	10	29
476	- Willpower is limited — structure your environment to support focus.	10	30
477	- Create rituals that minimize distractions (set start/end times, clear workspace).	10	31
478	- Work in defined, intense sessions instead of all day long.	10	32
479	- Choose a “depth philosophy” that fits your life:	10	33
481	=> Bimodal (alternate between deep and shallow periods).	10	35
482	=> Rhythmic (schedule deep work daily).	10	36
484		10	38
485	Rule #2: Embrace Boredom	10	39
486	- Train your brain to tolerate boredom instead of reaching for your phone.	10	40
487	- Don’t switch tasks when things get dull; learn to stay with the discomfort.	10	41
488	- Schedule internet or social media use intentionally, not habitually.	10	42
489		10	43
490	Rule #3: Quit Social Media	10	44
491	- Be selective with your digital tools.	10	45
492	- Ask: Does this tool bring substantial benefit to my goals?	10	46
493	- If not, eliminate it or limit its usage strictly.	10	47
494	- The goal: reduce mental clutter and regain focus.	10	48
495		10	49
496	Rule #4: Drain the Shallows	10	50
497	- Schedule your entire day — even breaks — to stay intentional.	10	51
498	- Prioritize tasks that matter; minimize meetings, emails, and “busy work.”	10	52
499	Set clear boundaries:	10	53
500	=> End work at a fixed time each day.	10	54
501	=> Say “no” to shallow commitments that don’t move you forward.	10	55
502		10	56
503		10	57
504	🔄 Key Strategies & Techniques	10	58
505	- Time-blocking: Plan every hour of your day for maximum control.	10	59
506	- Shutdown ritual: End each workday with a routine to signal your brain to rest.	10	60
507	- Focus sprints: 60–90 minutes of uninterrupted deep work with breaks.	10	61
508	- Attention residue: Avoid context-switching; it lowers focus quality.	10	62
509		10	63
510		10	64
511	🧘 Mindset Shifts	10	65
512	- Busyness ≠ productivity.	10	66
513	- Depth brings fulfillment; shallow tasks drain meaning.	10	67
514	- To do deep work, you must protect your time ruthlessly.	10	68
515	- The ability to concentrate is a skill — train it deliberately.	10	69
516		10	70
517		10	71
518	🏁 Key Takeaways	10	72
519	- Deep work is rare, valuable, and meaningful — cultivate it deliberately.	10	73
520	- Eliminate distractions, schedule focus time, and prioritize meaningful output.	10	74
521	- Shallow work is unavoidable but should be minimized and contained.	10	75
522	- Mastering deep work creates a clear competitive advantage in life and career.	10	76
523	💡 Core Message	7	1
524	- Financial success isn’t about knowledge or intelligence — it’s about behavior.	7	2
525	- How you think about money, risk, and decisions matters more than how you calculate returns.	7	3
526	- People make money decisions based on personal experiences, emotions, and biases — not logic.	7	4
527	- The goal is not to maximize wealth, but to achieve freedom, control, and peace of mind.	7	5
528	 	7	6
529	 	7	7
530	🧠 Key Lessons & Ideas	7	8
531	1️⃣ No One is Crazy	7	9
532	- Everyone has their own unique life experiences that shape how they view money.	7	10
533	- A person who grew up during economic hardship will treat money differently from someone raised during prosperity.	7	11
534	- Don’t judge others’ financial choices — what seems irrational to you might make perfect sense to them.	7	12
535	 	7	13
537	2️⃣ Luck and Risk	7	14
538	- Success is never 100% due to effort, and failure isn’t always due to mistakes.	7	15
539	- Luck and risk play a huge role in financial outcomes.	7	16
540	- Example: Bill Gates became successful partly because he had early access to a computer at one of the few schools that had one.	7	17
541	- Lesson: Be humble in success and empathetic in others’ failures.	7	18
542		7	19
543	3️⃣ Never Enough	7	20
544	- Many people keep chasing more money even when they have “enough.”	7	21
545	- Greed leads to poor decisions and unnecessary risks.	7	22
546	- “The hardest financial skill is getting the goalpost to stop moving.”	7	23
547	- Knowing when you have enough prevents burnout and financial ruin.	7	24
548		7	25
549	4️⃣ Compounding is Powerful	7	26
550	- Compounding is the most powerful force in finance — but it requires time and patience.	7	27
551	- Warren Buffett’s wealth didn’t come from extraordinary skill alone — it came from decades of consistent investing.	7	28
552	- Lesson: Time matters more than timing. Stay invested long-term.	7	29
553	 	7	30
554	5️⃣ Getting Wealthy vs. Staying Wealthy	7	31
555	- Getting rich requires risk-taking, optimism, and boldness.	7	32
556	- Staying rich requires humility, caution, and fear of loss.	7	33
557	- Wealth is what you don’t see — it’s the cars not bought, the vacations not taken, the luxury skipped to build security.	7	34
558	- Focus not just on earning, but on preserving wealth.	7	35
559		7	36
560	6️⃣ Tails Drive Everything	7	37
561	- Most success stories are driven by a few “tail events” — rare, impactful outcomes.	7	38
562	- A few great decisions or investments create the majority of results.	7	39
563	- Lesson: You don’t need to be perfect — just consistent enough to catch a few “tails.”	7	40
564		7	41
565	7️⃣ Freedom is the Ultimate Goal	7	42
566	- True wealth = the ability to control your time.	7	43
567	- Money buys you the freedom to do what you want, when you want, with whom you want.	7	44
568	- People don’t crave money itself — they crave autonomy and flexibility.	7	45
569	 	7	46
570	8️⃣ Man in the Car Paradox	7	47
571	- When people see someone with a fancy car, they admire the car, not the driver.	7	48
572	- Ironically, people buy luxury goods to impress others, but others rarely notice.	7	49
573	- Lesson: Don’t spend to impress; spend for genuine happiness and comfort.	7	50
574		7	51
575	9️⃣ Save Money	7	52
576	- Saving is the foundation of wealth — not because of high income, but low ego and discipline.	7	53
577	- Wealth is built by living below your means and saving consistently.	7	54
578	- Saving gives you options and flexibility in uncertain times.	7	55
579		7	56
580	🔟 Reasonable > Rational	7	57
581	- You don’t need to be perfectly rational with money — just reasonable and consistent.	7	58
582	- Personal finance is emotional; a “good enough” plan you can stick with beats a “perfect” plan you abandon.	7	59
583	- Example: Paying off a low-interest loan early may not be rational but can reduce stress — and that’s worth it.	7	60
584	 	7	61
585	1️⃣1️⃣ You’ll Change Over Time	7	62
586	- Your goals, risk tolerance, and values will evolve.	7	63
587	- Be flexible and adjust your financial strategies as your life changes.	7	64
588	- Don’t lock yourself into rigid long-term plans based on who you are today.	7	65
589	 	7	66
590	1️⃣2️⃣ Nothing’s Free	7	67
591	- Everything has a price — success, wealth, and investing all require enduring volatility, uncertainty, and risk.	7	68
592	- The cost of great returns is dealing with fear and doubt without panicking.	7	69
593	- “Volatility is the price of admission for superior returns.”	7	70
594	 	7	71
595	1️⃣3️⃣ You and Me	7	72
596	- Different people have different financial goals — what’s good for one investor may be terrible for another.	7	73
597	- Example: A retiree wants stability; a 25-year-old investor should embrace risk.	7	74
598	- Don’t copy others blindly — align your choices with your own time horizon and values.	7	75
599		7	76
600	1️⃣4️⃣ The Seduction of Pessimism	7	77
601	- Bad news feels more intelligent and realistic than optimism.	7	78
602	- But over time, optimism wins — progress is built on long-term belief in improvement.	7	79
603	- Stay rationally optimistic: things go wrong short-term but improve long-term.	7	80
604		7	81
605		7	82
606	🧭 Practical Advice	7	83
607	- Save consistently, even when it feels small.	7	84
608	- Avoid lifestyle inflation — define “enough.”	7	85
609	- Invest long-term, ignore short-term noise.	7	86
610	- Protect yourself from downside risk (emergency funds, diversification).	7	87
611	- Be humble — accept that luck and risk are always part of the equation.	7	88
612	 	7	89
613		7	90
614	🏁 Final Takeaways	7	91
615	- Wealth is behavioral, not intellectual.	7	92
616	- The best financial plan is one you can stick with for decades.	7	93
617	- Freedom > Luxury.	7	94
618	- Manage your emotions, expectations, and time horizon.	7	95
619	- The ultimate goal: a calm, secure, and meaningful life — not just more money.	7	96
620	Sorry, can't be bothered to write anything about this one.	12	1
621	🧠 Overview	6	1
622	- Written by Matthew Walker, a neuroscientist and sleep expert.	6	2
623	- The book explores why sleep is vital for our health, intelligence, emotions, and longevity.	6	3
624	- Walker argues that sleep is the most important biological function—as essential as food and water—yet modern society often neglects it.	6	4
625	 	6	5
626		6	6
627	🌙 1. The Purpose and Science of Sleep	6	7
628	- Sleep is not a passive state, but an active process that restores and enhances brain and body function.	6	8
629	There are two main types of sleep:	6	9
630	1. NREM (Non-Rapid Eye Movement) – deep, restorative sleep; helps with memory consolidation and physical repair.	6	10
631	2. REM (Rapid Eye Movement) – dream sleep; supports creativity, problem-solving, and emotional processing.	6	11
632	- The sleep cycle alternates between NREM and REM roughly every 90 minutes, repeating several times per night.	6	12
633		6	13
634		6	14
635	🕰️ 2. How Sleep Affects the Brain	6	15
636	- During sleep, the brain strengthens useful neural connections and prunes away unnecessary ones—this improves learning and decision-making.	6	16
637	1. Memory enhancement:	6	17
638	=> NREM sleep transfers short-term memories (in the hippocampus) into long-term storage (in the neocortex).	6	18
639	=> REM sleep links unrelated ideas, sparking creativity and insight.	6	19
640	2. Emotional regulation:	6	20
641	=> REM sleep acts like “overnight therapy,” reducing emotional intensity from the previous day’s experiences.	6	21
642	=> Lack of REM leads to mood swings, irritability, and anxiety.	6	22
643		6	23
644		6	24
645	💪 3. How Sleep Affects the Body	6	25
646	- Immune system: Sleep strengthens immune defenses; even one night of poor sleep lowers natural killer cell activity by up to 70%.	6	26
647	- Cardiovascular health: Consistent sleep deprivation raises blood pressure and increases the risk of heart disease, stroke, and diabetes.	6	27
648	- Metabolism & weight:	6	28
649	=> Lack of sleep disrupts hormones (ghrelin and leptin) that control hunger.	6	29
650	=> This leads to overeating and weight gain.	6	30
651	- Hormonal balance:	6	31
652	=> Reduces testosterone and growth hormone, impairing physical performance and recovery.	6	32
653		6	33
654		6	34
655	⏰ 4. The Dangers of Sleep Deprivation	6	35
656	- Sleep loss severely impairs attention, reaction time, and judgment—comparable to being drunk.	6	36
657	- After 16 hours awake, cognitive performance declines; at 20 hours, it’s equal to a blood alcohol level of 0.08%.	6	37
658	- Chronic sleep deprivation contributes to:	6	38
659	=> Alzheimer’s disease (due to accumulation of beta-amyloid plaques).	6	39
660	=> Depression and anxiety.	6	40
661	=> Weakened immune function and shorter lifespan.	6	41
662	- “You can’t cheat sleep”—you cannot “catch up” on weekends without long-term consequences.	6	42
663		6	43
664		6	44
665	💡 5. Myths and Misunderstandings About Sleep	6	45
666	- Myth: Some people only need 4–5 hours of sleep.	6	46
667	=> Reality: Less than 1% of people have a gene mutation allowing that. The rest suffer health consequences.	6	47
668	- Myth: Caffeine or alcohol helps sleep.	6	48
669	=> Caffeine blocks adenosine (sleep pressure) and stays in the system for 6–8 hours.	6	49
670	=> Alcohol fragments sleep and suppresses REM.	6	50
671	- Myth: Aging reduces sleep need.	6	51
672	=> The need remains the same; it’s just that older adults lose the ability to sleep deeply.	6	52
673	 	6	53
674	 	6	54
675	🧬 6. Sleep Across the Lifespan	6	55
676	- Infants & children need far more sleep (up to 16 hours/day) to support brain development.	6	56
677	- Teenagers have naturally shifted sleep cycles (they fall asleep and wake up later). Forcing early school times harms learning and mental health.	6	57
678	- Adults need about 7–9 hours per night for optimal health and productivity.	6	58
679	- Elderly people experience lighter, more fragmented sleep due to brain structure changes.	6	59
680		6	60
681		6	61
682	💤 7. Dreams and REM Sleep	6	62
683	- Dreams during REM are not random—they help process emotions, trauma, and creativity.	6	63
684	- During REM:	6	64
685	=> The brain’s emotional centers stay active.	6	65
686	=> The prefrontal cortex (rational control) is less active—allowing abstract thought and imagination.	6	66
687	- REM dreams act like overnight therapy, helping the mind recover from emotional distress.	6	67
688		6	68
689		6	69
690	⚙️ 8. How Society Undervalues Sleep	6	70
691	- Modern life glorifies busyness and sleep deprivation (“I’ll sleep when I’m dead”), which Walker calls a “public health crisis.”	6	71
692	- Work schedules, artificial light, and screen exposure disrupt our circadian rhythm—the internal 24-hour clock controlling sleep and wakefulness.	6	72
693	- Schools and companies should start later to align with natural sleep cycles and boost performance.	6	73
694		6	74
695		6	75
696	🌅 9. Improving Sleep Quality (Practical Tips)	6	76
697	- Keep a consistent sleep schedule, even on weekends.	6	77
698	- Avoid screens and bright light 1–2 hours before bed; light suppresses melatonin release.	6	78
699	- Cool environment (18°C or 65°F) promotes better sleep.	6	79
700	- Avoid caffeine after noon and alcohol before bed.	6	80
701	- Get sunlight exposure early in the day to anchor your circadian rhythm.	6	81
702	- Create a bedtime routine—dim lights, relax, and wind down mentally.	6	82
703	- Don’t stay in bed awake; if you can’t sleep, get up and do something relaxing until sleepy again.	6	83
704		6	84
705		6	85
706	🌍 10. The Broader Impact of Sleep	6	86
707	- Societies with widespread sleep deprivation suffer from:	6	87
708	=> Lower productivity and creativity.	6	88
709	=> More accidents (especially car crashes).	6	89
710	=> Higher healthcare costs.	6	90
711	- Walker advocates for:	6	91
712	=> Later school start times.	6	92
713	=> Sleep education.	6	93
714	=> Workplace policies that prioritize rest and recovery.	6	94
716		6	95
717		6	96
718	🧩 Key Takeaways	6	97
719	- Sleep is the foundation of health—it improves learning, emotional stability, and longevity.	6	98
720	- There is no biological substitute for adequate sleep.	6	99
721	- Treat sleep like a non-negotiable investment—not a luxury.	6	100
722	- “The shorter your sleep, the shorter your lifespan.”	6	101
723	🧠 Overview	8	1
727	- The goal: learn to adapt your communication style to others instead of assuming everyone thinks like you.	8	5
725	The book explains why people think, act, and communicate differently, and how understanding personality types can improve relationships, teamwork, and leadership.	8	3
724	- Written by Thomas Erikson, a Swedish behavioral expert.	8	2
726	- Erikson divides people into four main personality colors — Red, Yellow, Green, and Blue — based on the DISC model (Dominance, Influence, Steadiness, Compliance).	8	4
728		8	6
729		8	7
730	🎨 1. The Four Personality Types	8	8
731	🔴 Red – The Dominant	8	9
732	- Driven, competitive, decisive, and goal-oriented.	8	10
733	- Values efficiency, results, and control.	8	11
734	- Strengths: Leadership, confidence, quick decision-making, ambition.	8	12
735	- Weaknesses: Impatient, blunt, sometimes insensitive, struggles with details.	8	13
736	- Best way to communicate: Be direct, concise, and focus on results — don’t waste their time.	8	14
737	Example behavior: “Just tell me what needs to be done.”	8	15
738		8	16
739	🟡 Yellow – The Socializer	8	17
740	- Optimistic, enthusiastic, talkative, and creative.	8	18
741	- Values relationships, energy, and recognition.	8	19
742	- Strengths: Inspiring, persuasive, adaptable, fun to be around.	8	20
743	- Weaknesses: Easily distracted, poor with details or follow-through, can dominate conversations.	8	21
744	- Best way to communicate: Be open, friendly, and positive — make them feel heard and appreciated.	8	22
745	Example behavior: “Let’s make this fun and exciting!”	8	23
746		8	24
747	🟢 Green – The Supporter	8	25
748	- Calm, patient, loyal, and consistent.	8	26
749	- Values stability, harmony, and security.	8	27
750	- Strengths: Reliable, empathetic, good listener, great team player.	8	28
751	- Weaknesses: Avoids conflict, resistant to change, indecisive.	8	29
752	- Best way to communicate: Be gentle, patient, and give them time to adjust — avoid being pushy.	8	30
753	Example behavior: “Let’s make sure everyone is okay with this first.”	8	31
754		8	32
755	🔵 Blue – The Analyzer	8	33
756	- Logical, detail-oriented, and perfectionistic.	8	34
757	- Values accuracy, facts, and structure.	8	35
758	- Strengths: Thorough, disciplined, data-driven, high standards.	8	36
759	- Weaknesses: Overthinks, slow to decide, critical, emotionally distant.	8	37
760	- Best way to communicate: Be factual, precise, and well-prepared — avoid emotional exaggeration.	8	38
761	Example behavior: “Do you have the data to back that up?”	8	39
762		8	40
763		8	41
764	⚖️ 2. Everyone Has a Mix of Colors	8	42
765	- Most people are not purely one color — they usually have a primary and secondary color.	8	43
766	Example: A “Red-Yellow” might be an ambitious extrovert, while a “Green-Blue” might be a loyal but detail-focused planner.	8	44
767	- Understanding your mix helps you identify your strengths, blind spots, and communication style.	8	45
768		8	46
769		8	47
770	💬 3. How Miscommunication Happens	8	48
771	- People assume others think and react like them — this causes misunderstandings.	8	49
772	Example:	8	50
773	=> A Red boss might think a Green employee is lazy because they’re not aggressive.	8	51
774	=> A Blue might find a Yellow unreliable because they change ideas often.	8	52
775	- The truth: They’re not wrong or stupid — they’re just different.	8	53
776	- Effective communication means adapting your tone, pace, and content to match the other person’s style.	8	54
777		8	55
778		8	56
779	🧩 4. How to Work with Each Type	8	57
780	- With Reds: Be confident and results-oriented; don’t waste time on small talk.	8	58
781	- With Yellows: Be enthusiastic and open-minded; listen to their ideas and praise creativity.	8	59
782	- With Greens: Be patient and kind; give them stability and reassurance.	8	60
783	- With Blues: Be logical and well-prepared; respect their need for facts and structure.	8	61
784		8	62
785		8	63
786	🏢 5. Applying It in Real Life	8	64
787		8	65
788	In leadership:	8	66
789	=> Adapt leadership style based on team members’ color types.	8	67
790	=> Reds need challenges, Yellows need excitement, Greens need reassurance, Blues need clarity.	8	68
791		8	69
792	In teamwork:	8	70
793	=> Balance different colors for stronger collaboration.	8	71
794	=> Too many Reds = conflict; too many Greens = stagnation.	8	72
795		8	73
796	In relationships:	8	74
797	=> Understanding your partner’s color helps reduce arguments and improve empathy.	8	75
798		8	76
799		8	77
800	⚙️ 6. Common Color Conflicts	8	78
801	Red vs Blue: Clash between speed and accuracy.	8	79
802	Red vs Green: Conflict between dominance and passivity.	8	80
803	Yellow vs Blue: Creativity vs structure tension.	8	81
804	Yellow vs Green: Spontaneity vs stability.	8	82
805	- Recognizing these clashes allows you to bridge the gap instead of taking it personally.	8	83
806	 	8	84
807		8	85
808	🧭 7. Self-Awareness and Growth	8	86
809	- The first step is understanding your own color type — what motivates you, how you react to stress, and how others perceive you.	8	87
810	- Then, learn to spot others’ colors through observation:	8	88
811	=> Speech: Fast or slow? Emotional or factual?	8	89
812	=> Body language: Open or reserved?	8	90
813	=> Decision style: Impulsive or cautious?	8	91
814	- Once you identify someone’s type, adapt — not to manipulate, but to connect better.	8	92
815		8	93
816		8	94
817	🌱 8. Key Lessons	8	95
818	- No one color is “better” than another — each has strengths and weaknesses.	8	96
819	- Communication isn’t about changing others, but understanding and adapting.	8	97
820	- The key to successful interaction is empathy + flexibility.	8	98
821	“Surrounded by idiots” is really about realizing:	8	99
822	You’re only surrounded by idiots when you don’t understand how people think differently.	8	100
823		8	101
824		8	102
825	💡 9. Practical Takeaways	8	103
826	- Observe first, react later — identify color before responding.	8	104
827	- Adjust tone and speed to match the person’s energy level.	8	105
828	- Use their language — results for Reds, fun for Yellows, comfort for Greens, facts for Blues.	8	106
829	- In conflicts: Step into the other person’s color zone instead of forcing them into yours.	8	107
830	- In leadership and sales: The ability to read and adapt to colors determines success.	8	108
831		8	109
832		8	110
\.

-- Session data intentionally left blank for security
COPY public.session (sid, sess, expire) FROM stdin;
\.

-- Only the Demo User is retained. Personal account removed.
COPY public.users (id, email, password, image_url, fname, lname) FROM stdin;
00000000-0000-0000-0000-000000000001	demo@typr.io	demo123	https://cdn-icons-png.flaticon.com/512/147/147144.png	Demo	User
\.

-- 3. SEQUENCE RESETS
SELECT pg_catalog.setval('public.books_id_seq', 17, true);
SELECT pg_catalog.setval('public.comments_id_seq', 6, true);
SELECT pg_catalog.setval('public.notes_id_seq', 832, true);

-- 4. CONSTRAINTS & INDEXES
ALTER TABLE ONLY public.books ADD CONSTRAINT books_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.comments ADD CONSTRAINT comments_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.notes ADD CONSTRAINT notes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.session ADD CONSTRAINT session_pkey PRIMARY KEY (sid);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);

ALTER TABLE ONLY public.comments ADD CONSTRAINT comments_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.comments ADD CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.notes ADD CONSTRAINT notes_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id) ON DELETE CASCADE;

-- Note: The Cloud SQL specific GRANT command has been removed to ensure local compatibility.