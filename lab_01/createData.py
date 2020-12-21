# -*- coding: utf8 -*-
import os
import string
import random
import re

man_names = "АаронАбрамАвазАвгустинАвраамАгапАгапитАгатАгафонАдамАдрианАзаматАзатАзизАидАйдарАйратАкакийАкимАланАлександрАлексейАлиАликАлимАлиханАлишерАлмазАльбертАмирАмирамАмиранАнарАнастасийАнатолийАнварАнгелАндрейАнзорАнтонАнфимАрамАристархАркадийАрманАрменАрсенАрсенийАрсланАртёмАртемийАртурАрхипАскарАсланАсханАсхатАхметАшотБахрамБенджаминБлезБогданБорисБориславБрониславБулатВадимВалентинВалерийВальдемарВарданВасилийВениаминВикторВильгельмВитВиталийВладВладимирВладиславВладленВласВсеволодВячеславГавриилГамлетГарриГеннадийГенриГенрихГеоргийГерасимГерманГерманнГлебГордейГригорийГуставДавидДавлатДамирДанаДаниилДанилДанисДаниславДаниэльДаниярДарийДауренДемидДемьянДенисДжамалДжанДжеймсДжеремиДжозефДжонатанДикДинДинарДиноДмитрийДобрыняДоминикЕвгенийЕвдокимЕвсейЕвстахийЕгорЕлисейЕмельянЕремейЕфимЕфремЖданЖерарЖигерЗакирЗаурЗахарЗенонЗигмундЗиновийЗурабЗуфарИбрагимИванИгнатИгнатийИгорьИеронимИисусИльгизИльнурИльшатИльяИльясИмранИннокентийИраклийИсаакИсаакийИсидорИскандерИсламИсмаилИтанКазбекКамильКаренКаримКарлКимКирКириллКлаусКлимКонрадКонстантинКореКорнелийКристианКузьмаЛаврентийЛадоЛевЛенарЛеонЛеонардЛеонидЛеопольдЛоренсЛукаЛукиллианЛукьянЛюбомирЛюдвигЛюдовикЛюцийМаджидМайклМакарМакарийМаксимМаксимилианМаксудМансурМарМаратМаркМарсельМартинМартынМатвейМахмудМикаМикулаМилославМиронМирославМихаилМоисейМстиславМуратМуслимМухаммедМэтьюНазарНаильНариманНатанНесторНикНикитаНикодимНиколаНиколайНильсОгюстОлегОливерОрестОрландоОсипИосифскарОсманОстапОстинПавелПанкратПатрикПедроПерриПётрПлатонПотапПрохорРавильРадийРадикРадомирРадославРазильРаильРаифРайанРаймондРамазанРамзесРамизРамильРамонРанельРасимРасулРатиборРатмирРаушанРафаэльРафикРашидРинатРичардРобертРодимРодионРожденРоланРоманРостиславРубенРудольфРусланРустамРэйСавваСавелийСаидСалаватСаматСамвелСамирСамуилСанжарСаниСаянСвятославСевастьянСемёнСерафимСергейСидорСимбаСоломонСпартакСтаниславСтепанСулейманСултанСуренТагирТаирТайлерТалгатТамазТамерланТарасТахирТигранТимофейТимурТихонТомасТрофимУинслоуУмарУстинФазильФаридФархадФёдорФедотФеликсФилиппФлорФомаФредФридрихХабибХакимХаритонХасанЦезарьЦефасЦецилийЦицеронЧарльзЧеславЧингизШамильШарльШерлокЭдгарЭдуардЭльдарЭмильЭминЭрикЭркюльЭрминЭрнестЭузебиоЮлианЮлийЮнусЮрийЮстинианЮстусЯковЯнЯромирЯрослав"
woman_names = "АваАвгустаАвгустинаАвдотьяАврораАгапияАгатаАгафьяАглаяАгнияАгундаАдаАделаидаАделинаАдельАдиляАдрианаАзаАзалияАзизаАидаАишаАйАйаруАйгеримАйгульАйлинАйнагульАйнурАйсельАйсунАйсылуАксиньяАланаАлевтинаАлександраАлёнаАлестаАлинаАлисаАлияАллаАлсуАлтынАльбаАльбинаАльфияАляАмалияАмальАминаАмираАнаитАнастасияАнгелинаАнжелаАнжеликаАнисьяАнитаАннаАнтонинаАнфисаАполлинарияАрабеллаАриаднаАрианаАриандаАринаАрияАсельАсияАстридАсяАфинаАэлитаАяАянаБаженаБеатрисБелаБелиндаБеллаБертаБогданаБоженаБьянкаВалентинаВалерияВандаВанессаВарвараВасилинаВасилисаВенераВераВероникаВестаВетаВикторинаВикторияВиленаВиолаВиолеттаВитаВиталинаВиталияВладаВладанаВладиславаГабриэллаГалинаГалияГаянаГаянэГенриеттаГлафираГоарГретаГульзираГульмираГульназГульнараГульшатГюзельДалидаДамираДанаДаниэлаДанияДараДаринаДарьяДаянаДжамиляДженнаДженниферДжессикаДжиневраДианаДильназДильнараДиляДилярамДинаДинараДолоресДоминикаДомнаДомникаЕваЕвангелинаЕвгенияЕвдокияЕкатеринаЕленаЕлизаветаЕсенияЕяЖаклинЖаннаЖансаяЖасминЖозефинаЖоржинаЗабаваЗаираЗалинаЗамираЗараЗаремаЗаринаЗемфираЗинаидаЗитаЗлатаЗлатославаЗорянаЗояЗульфияЗухраИветтаИзабеллаИлинаИллирикаИлонаИльзираИлюзаИнгаИндираИнессаИннаИоаннаИраИрадаИраидаИринаИрмаИскраИяКамилаКамиллаКараКареКаримаКаринаКаролинаКираКлавдияКлараКонстанцияКораКорнелияКристинаКсенияЛадаЛанаЛараЛарисаЛаураЛейлаЛеонаЛераЛесяЛетаЛианаЛидияЛизаЛикаЛилиЛилианаЛилитЛилияЛинаЛиндаЛиораЛираЛияЛолаЛолитаЛораЛуизаЛукерьяЛукияЛунаЛюбаваЛюбовьЛюдмилаЛюсильЛюсьенаЛюцияЛючеЛяйсанЛяляМавилеМавлюдаМагдаМагдалeнаМадинаМадленМайяМакарияМаликаМараМаргаритаМарианнаМарикаМаринаМарияМариямМартаМарфаМеланияМелиссаМехриМикаМилаМиладаМиланаМиленМиленаМилицаМилославаМинаМираМирославаМирраМихримахМишельМияМоникаМузаНадеждаНаиляНаимаНанаНаомиНаргизаНатальяНеллиНеяНикаНикольНинаНинельНоминаНоннаНораНурияОдеттаОксанаОктябринаОлесяОливияОльгаОфелияПавлинаПамелаПатрицияПаулаПейтонПелагеяПеризатПлатонидаПолинаПрасковьяРавшанаРадаРазинаРаиляРаисаРаифаРалинаРаминаРаянаРебеккаРегинаРезедаРенаРенатаРианаРианнаРикардаРиммаРинаРитаРогнедаРозаРоксанаРоксоланаРузалияРузаннаРусалинаРусланаРуфинаРуфьСабинаСабринаСажидаСаидаСалимаСаломеяСальмаСамираСандраСанияСараСатиСаулеСафияСафураСаянаСветланаСевараСеленаСельмаСерафимаСильвияСимонаСнежанаСоняСофьяСтеллаСтефанияСусаннаТаисияТамараТамилаТараТатьянаТаяТаянаТеонаТерезаТеяТинаТиффаниТомирисТораТэммиУльянаУмаУрсулаУстиньяФазиляФаинаФаридаФаризаФатимаФедораФёклаФелиситиФелицияФерузаФизалияФирузаФлораФлорентинаФлоренцияФлорианаФредерикаФридаХадияХилариХлояХюрремЦаганаЦветанаЦецилияЦиараЧелсиЧеславаЧулпанШакираШарлоттаШахинаШейлаШеллиШерилЭвелинаЭвитаЭлеонораЭлианаЭлизаЭлинаЭллаЭльвинаЭльвираЭльмираЭльнараЭляЭмилиЭмилияЭммаЭнжеЭрикаЭрминаЭсмеральдаЭсмираЭстерЭтельЭтериЮлианнаЮлияЮнаЮнияЮнонаЯдвигаЯнаЯнинаЯрина"
man_names = re.findall("[А-Я][^А-Я]*", man_names)
woman_names = re.findall("[А-Я][^А-Я]*", woman_names)

def createPeople(minAge, maxAge):
    id = random.randint(0, 100000)
    if random.randint(0, 100) % 2 == 0:
        name = random.choice(man_names)
        surname = random.choice(man_names) + "ович"
    else:
        name = random.choice(woman_names)
        surname = random.choice(man_names)+ "овна"
    login = ""
    login += random.choice(string.ascii_uppercase)
    for i in range(6):
        login += random.choice(string.ascii_lowercase)
    age = random.randint(minAge, maxAge)
    return id, login, name, surname, age


## with os.open("Professors.csv") as file:
professors = []
ids = set()
logins = set()
for i in range(0, 1100):
    people = createPeople(18, 75)
    if people[0] not in ids and people[1] not in logins:
        ids.add(people[0])
        logins.add(people[1])
        professors.append(people)
    else:
        print("dup\n")
print(len(professors))


# groups
groups = []
enrollSemesters = [0, 1, 2, 3, 4, 5, 6]
namesFac = ["ИУ", "СМ", "РК", "РЛ", "АК"]
ids = set()

for name in namesFac:
    for enroll in enrollSemesters:
        for number in range(1, 3):
            for caff in range(1, 7):
                id = random.randint(0, 9999999)
                while id in ids:
                    id = random.randint(0, 9999999)
                ids.add(id)
                groups.append((id, name + str(caff) + "-" + str(number), enroll))
print(groups)


subjects = [ (0, "OOP"), (1, "c-prog"), (2, "database"), (3, "algorithm"), (4, "python"), (5, "physic"),
            (6, "operation-system"), (7, "c-prog-second-part"), (8, "TaSD"), (9, "defence-against-the-dark-art"), (10, "quidditch")]


students = []
ids = set()
logins = set()

print("\n\nSTUDENT\n\n")
for i in range(0, 10000):
    people = createPeople(15, 30)
    if people[0] not in ids and people[1] not in logins:
        ids.add(people[0])
        logins.add(people[1])
        a = tuple((random.choice(groups)[0],))
        students.append((people[0], a[0], people[1], people[2], people[3], people[4]))
    else:
        print("dup\n")
print(students)




subjectInfos = []
ids = set()
logins = set()

for semester in enrollSemesters:
    for subject in subjects:
        while id in ids:
            id = random.randint(0, 9999999)
        ids.add(id)
        subjectInfos.append((id, subject[0], semester))
#print(subjectInfos)



subjectInfosStudentGroups = []
ids = set()
logins = set()
'''
У всех всегда физика.
У всех ИУ на 1, 2 семестре ООП.
У РК и РЛ всегда "defence..."
АК, СМ - квиддич.
Если кафедра - 1-3, то c-prog на 1 -3 семе и то с-prog-second на 4-6 семе.
4-7, то alg на 1 -3 семе и database на 4-6 семе
У иу3-7 на 3-6 семе - python
У АК на 1,3,5 - os
У РК на 2,4,6 - tasd
'''
id = 0
for subjectInfo in subjectInfos:
    for group in groups:
        id += 1
        if id not in ids and subjectInfo[1] == 0 and (
            subjectInfo[2] - group[2] in [1, 0] and "ИУ" in group[1]
            ):
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        if id not in ids and subjectInfo[1] == 1 and (
            group[1] == "3" or group[1] == "2" or group[1] == "1"
        ) and subjectInfo[2] - group[2] in [0, 1, 2]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        if id not in ids and subjectInfo[1] == 2 and (
            group[1] == "4" or group[1] == "5" or group[1] == "6" or group[1] == "7"
        ) and subjectInfo[2] - group[2] in [3, 4, 5, 6]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        if id not in ids and subjectInfo[1] == 3 and (
        group[1] == "4" or group[1] == "5" or group[1] == "6" or group[1] == "7"
        ) and subjectInfo[2] - group[2] in [0, 1, 2]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))

        if id not in ids and subjectInfo[1] == 4 and (
        "ИУ3" in group[1] or "ИУ4" in group[1] or "ИУ5" in group[1] or "ИУ6" in group[1] or "ИУ7" in group[1]
        ) and subjectInfo[2] - group[2] in [2, 3, 4, 5]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        
        if id not in ids and subjectInfo[1] == 5:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        
        if id not in ids and subjectInfo[1] == 6 and (
        "АК" in group[1]
        ) and subjectInfo[2] - group[2] in [0, 2, 4]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        
        if id not in ids and subjectInfo[1] == 7 and (
            group[1] == "3" or group[1] == "2" or group[1] == "1"
        ) and subjectInfo[2] - group[2] in [3, 4, 5]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        
        if id not in ids and subjectInfo[1] == 8 and (
        "РК" in group[1]
        ) and subjectInfo[2] - group[2] in [1, 3, 5]:
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))


        if id not in ids and subjectInfo[1] == 9 and (
        "РК" in group[1] or "РЛ" in group[1]):
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
        
        if id not in ids and subjectInfo[1] == 10 and (
        "АК" in group[1] or "СМ" in group[1]):
            subjectInfosStudentGroups.append((subjectInfo[0], group[0]))
#print(subjectInfosStudentGroups)


projects = []
ids = set()
logins = set()

for subjectInfo in subjectInfos:
        id = random.randint(0, 9999999)
        while id in ids:
            id = random.randint(0, 9999999)
        ids.add(id)
        projects.append((id, "Lab", 1, subjectInfo[0]))
#print(projects)

repositories = []
studentsRepositories = []
ids = set()
logins = set()

for project in projects:
    for subjectInfo in subjectInfos:
        if subjectInfo[0] == project[3]:
            for subjectInfosStudentGroup in subjectInfosStudentGroups:
                if subjectInfosStudentGroup[0] == subjectInfo[0]:
                    for student in students: 
                        if student[1] == subjectInfosStudentGroup[1]:
                            for subject in subjects:
                                if subject[0] == subjectInfo[1]:
                                    id = random.randint(0, 9999999)
                                    while id in ids:
                                        id = random.randint(0, 9999999)
                                    ids.add(id)
                                    repositories.append((id, subject[1] + "-" + str(subjectInfo[2]) + "-" + student[2], project[0]))
                                    studentsRepositories.append((student[0], id))
print(len(studentsRepositories))

professorsSubjects = []
for prof in professors:
    for i in range(random.randint(1, 3)):
        sub = random.choice(subjects)[0]
        if (tuple((prof[0], sub)) not in professorsSubjects):
            professorsSubjects.append(tuple((prof[0], sub)))
print(professorsSubjects)

with open("Professors.csv", "w", encoding="utf-8") as file:
    for prof in professors:
        file.write(str(prof[0]) + ", " + str(prof[1]) + ", " + str(prof[2]) + ", " + str(prof[3]) + ", " + str(prof[4]) + "\n")
    file.close()

with open("Subjects.csv", "w", encoding="utf-8") as file:
    for sub in subjects:
        file.write(str(sub[0]) + ", " + str(sub[1]) + "\n")
    file.close()

with open("StudentGroups.csv", "w", encoding="utf-8") as file:
    for group in groups:
        file.write(str(group[0]) + ", " + str(group[1]) + ", " + str(group[2]) + "\n")
    file.close()

with open("Students.csv", "w", encoding="utf-8") as file:
    for student in students:
        file.write(str(student[0]) + ", " + str(student[1]) + ", " + str(student[2]) + ", " + str(student[3]) + ", " + str(student[4]) + ", " + str(student[5]) + "\n")
    file.close()

with open("SubjectInfos.csv", "w", encoding="utf-8") as file:
    for subjectInfo in subjectInfos:
        file.write(str(subjectInfo[0]) + ", " + str(subjectInfo[1]) + ", " + str(subjectInfo[2]) + "\n")
    file.close()

with open("Projects.csv", "w", encoding="utf-8") as file:
    for project in projects:
        file.write(str(project[0]) + ", " + str(project[1]) + ", " + str(project[2]) + ", " + str(project[3]) + "\n")
    file.close()

with open("Repositories.csv", "w", encoding="utf-8") as file:
    for rep in repositories:
        file.write(str(rep[0]) + ", " + str(rep[1]) + ", " + str(rep[2]) + "\n")
    file.close()

with open("ProfessorsSubjects.csv", "w", encoding="utf-8") as file:
    for ps in professorsSubjects:
        file.write(str(ps[0]) + ", " + str(ps[1]) + "\n")
    file.close()

with open("SubjectInfosStudentGroups.csv", "w", encoding="utf-8") as file:
    for sg in subjectInfosStudentGroups:
        file.write(str(sg[0]) + ", " + str(sg[1]) + "\n")
    file.close()

with open("StudentsRepositories.csv", "w", encoding="utf-8") as file:
    for sp in studentsRepositories:
        file.write(str(sp[0]) + ", " + str(sp[1]) + "\n")
    file.close()
