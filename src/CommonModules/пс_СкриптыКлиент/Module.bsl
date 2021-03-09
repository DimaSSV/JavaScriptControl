
#Область ОбщегоНазначения

// Процедура инициализирует глобальную переменную для кеширования данных на клиенте
//
Процедура ПередНачаломРаботыСистемы() Экспорт
	
	пс_ПараметрыПриложения = Новый Соответствие;
	
	Обработчики = ПолучитьОбработчикиПолученияПараметров();
	
	// Установка параметров, требующих вызов сервера
	РезультатОбработкиНаСервере = пс_СкриптыВызовСервера.УстановкаПараметровКлиента(Обработчики);
	Для Каждого текПараметр Из РезультатОбработкиНаСервере Цикл
		пс_ПараметрыПриложения.Вставить(текПараметр.Ключ, текПараметр.Значение);
	КонецЦикла;
	
	// ToDo: Распаковываются все файлы.Подключать только по требованию?
	пс_ПодключениеБиблиотекКлиент.РаспаковатьФайлыПодключаемыхБиблиотек(Истина);
	
КонецПроцедуры

// Возвращает сохранённое значение из хранилища на клиенте
// Значение получается по переданному ключу
//
// Параметры:
//	Ключ - Любой - Ключ, для поиска значения в глобальном кеше
//
// Возвращаемое значение:
//   Любой   - Значение, сохранённое в глобальной клиентской переменной пс_ПараметрыПриложения
//
Функция ПолучитьИзКэша(Ключ) Экспорт 

	Возврат пс_ПараметрыПриложения[Ключ];

КонецФункции

// сохраняет значение в клиентком кэше
//
// Параметры:
//  Ключ  - Любой - Ключ для сохранения настройки
//  Значение  - Любой - значение для сохранения в клиентском кэше
//
Процедура ПоместитьВКэш(Ключ, Значение) Экспорт 

	пс_ПараметрыПриложения[Ключ] = Значение;

КонецПроцедуры

// Возвращает сохранённые данные формы. 
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - Форма, для который необходимо получить кэш
//
// Возвращаемое значение:
//   Соответствие  - Хранилище для кеширование данных формы
//
Функция ПолучитьКешФормы(Форма) Экспорт
	КлючНастройки = СтрШаблон("КешФормы.%1", Форма.УникальныйИдентификатор);
	Кеш = пс_ПараметрыПриложения[КлючНастройки];
	Если Кеш = Неопределено Тогда
		Кеш = Новый Соответствие;
		ПоместитьКешФормы(Форма ,Кеш);
	КонецЕсли;
	Возврат Кеш;
КонецФункции

//Сохраняет данные формы в клиентской переменной пс_ПараметрыПриложения.
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - Форма, для который необходимо сохранить кэш
//  Кеш  - Соответствие - Данные, которые буут сохранены в хранилище
//
Процедура ПоместитьКешФормы(Форма, Кеш) Экспорт
	КлючНастройки = СтрШаблон("КешФормы.%1", Форма.УникальныйИдентификатор);
	пс_ПараметрыПриложения[КлючНастройки] = Кеш;
КонецПроцедуры

// Удаляет данные формы их хранилища
//
// Параметры:
//  Форма  - ФормаКлиентскогоПриложения - Форма, для которой необходимо очистить хранилище
//
Процедура ОчиститьКешФормы(Форма) Экспорт
	КлючНастройки = СтрШаблон("КешФормы.%1", Форма.УникальныйИдентификатор);
	пс_ПараметрыПриложения.Удалить(КлючНастройки);
КонецПроцедуры

// Возвращает данные, сохранённые для переданного поля
//
// Параметры:
//  Ключ  - Любой - Ключ для получения сохранённого значения
//  		если передано неопределено, то будет возвращено соответствие со всеми сохранёнными данными
//  		если передан ключ, то будет возращено значение по переданному ключу.
//  Поле  - ПолеФормы - Поле, для которого будет получен кэш
//  		Если передано неопределено, то будет получено поле из переменной пс_ПараметрыПриложения["ПолеПоУмолчанию"]
//
// Возвращаемое значение:
//   Соответствие, Любой   - полный кэш формы, либо конкретное значение
//
Функция ПолучитьКешПоля(Ключ = Неопределено, Знач Поле = Неопределено) Экспорт
	Поле = ПолучитьПолеХТМЛ(Поле);
	Форма = НайтиФормуЭлемента(Поле);	
	КешФормы = ПолучитьКешФормы(Форма);
	КешПоля = КешФормы[Поле.Имя];
	Если КешПоля = Неопределено Тогда
		КешПоля = Новый Соответствие();
		КешФормы[Поле.имя] = КешПоля;
		ПоместитьКешФормы(Форма, КешФормы);
	КонецЕсли;
	Если Ключ = Неопределено Тогда
		Возврат КешПоля;
	Иначе
		Возврат КешПоля[Ключ];
	КонецЕсли;
КонецФункции

// Сохраняет данные в хранилище клиентского кэша.
//
// Параметры:
//  Ключ  - Любой - Ключ для сохранения значения в кэше поля
//  Значение  - Любой - значение, которое будет сохранено в кэшк поля по переданному ключу
//  Поле  - ПолеФормы - Поле, для которого будет сохранён кэш
//
Процедура ПоместитьКешПоля(Ключ, Значение, Знач Поле = Неопределено) Экспорт
	Поле = ПолучитьПолеХТМЛ(Поле);
	Форма = НайтиФормуЭлемента(Поле);
	КешФормы = ПолучитьКешФормы(Форма);
	КешПоля = ПолучитьКешПоля(,Поле);
	КешПоля[Ключ] = Значение;
	КешФормы[Поле.Имя] = КешПоля;
	ПоместитьКешФормы(Форма, КешФормы);
КонецПроцедуры

// функция возвращает соответствие клиентских параметров и обработчиков получения значения
//	В результате можно получить все параметры за один вызов сервера. Выполняется перед началом работы системы 
//
// Возвращаемое значение:
//   Соответствие   - Ключ = Имя параметра, Значение = функция получения значения.
//		Обработчик должен быт доступен на сервере и не содержать параметров. 
//		Пример:  "пс_СкриптыСерверПовтИсп.АдресОсновногоРасширенияСкриптов" 
//
Функция ПолучитьОбработчикиПолученияПараметров()

	Результат = Новый Соответствие;
	Результат.Вставить("АдресОсновногоРасширенияСкриптов", "пс_СкриптыСерверПовтИсп.АдресОсновногоРасширенияСкриптов");
	Возврат Результат;
	
КонецФункции // ПолучитьОбработчикиПолученияПараметров()
	
	
	
#КонецОбласти

#Область КешированиеПоляИнтерпритатора

// Сохраняет поле формы с видом "ПолеХТМЛ" для использования как поле по умолчанию.
//
// Параметры:
//   Поле - ПолеФормы - поле, которое будет использоваться по умолчанию
//   Тоесть в случае, когда в методы подсистемы параметр Поле не передаётся 
//
Процедура УстановитьПолеХТМЛПоУмолчанию(Поле) Экспорт 

	пс_ПараметрыПриложения["ПолеПоУмолчанию"] = Поле;		

КонецПроцедуры // УстановитьПолеХТМЛПоУмолчанию()

// Возвращает ранее сохранённое поле по умолчанию
//
// Возвращаемое значение:
//   ПолеФормы, Неопределено  - Значение поля по умолчанию
//
Функция ПолучитьПолеХТМЛПоУмолчанию() Экспорт 

	Возврат пс_ПараметрыПриложения["ПолеПоУмолчанию"];

КонецФункции // ПолучитьПолеХТМЛПоУмолчанию()

#КонецОбласти

#Область ДиалогиВзаимодействия

// Вызывает оповещение пользователя, с помощью javascript метода alert
//
// Параметры:
//  текстСообщения  - Строка - текст сообщения, который будет показан пользователю
//  ВычисляемоеСообщение  - Булево - Если передано Ложь, то сообщение показывается как есть.
//  			Если перено Истина, то текст сообщения будет вычислен в контексте "self"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура   
//
Процедура СообщитьСкриптом(Знач текстСообщения, ВычисляемоеСообщение = Ложь, Поле = Неопределено) Экспорт 

	Если ВычисляемоеСообщение Тогда
		Команда = СтрШаблон("alert(eval(%1))",текстСообщения);
	Иначе
		Команда = СтрШаблон("alert('%1')", текстСообщения);
	КонецЕсли;
	ВыполнитьКоманду(Команда, Поле);

КонецПроцедуры // СообщитьСкриптом()

// Вызывает вопрос пользователю, с помощью javascript метода confirm
//
// Параметры:
//  текстВопроса  - Строка - текст вопроса, который будет показан пользователю
//  ВычисляемоеСообщение  - Булево - Если передано Ложь, то текст вопроса показывается как есть.
//  			Если перено Истина, то текст вопроса будет вычислен в контексте "self"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Булево   - Истина, если была нажата кнопка Ok, в остальных случаях вернёт Ложь
//
Функция ВопросДаНет(Знач текстВопроса, ВычисляемоеСообщение = Ложь, Поле =  Неопределено) Экспорт 

	Если ВычисляемоеСообщение Тогда
		Команда = СтрШаблон("confirm(eval(%1))",текстВопроса);
	Иначе
		Команда = СтрШаблон("confirm('%1')", текстВопроса);
	КонецЕсли;
	Возврат ВыполнитьКоманду(Команда, Поле);

КонецФункции // ВопросДаНет()

#КонецОбласти

#Область Команды

// Выполняет переданное выражение javascript в глобальном контексте self. 
// для вычисления выражения ипользуется переданное поле формы или поле по умолчанию
//
// Параметры:
//  ТекстСкрипта  - Строка - текст выражения на языке javascript. Контекст выполнения "self"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект, Число, Строка, Булево, Неопределено   - Результат вычисления js выражения
//
Функция ВыполнитьКоманду(ТекстСкрипта, Поле = Неопределено) Экспорт 
			
	Результат = ИнтерприаторСкриптов(Поле).Eval(ТекстСкрипта);
	ПроверитьОтвет(Результат);
	Возврат Результат.result;

КонецФункции // ВыполнитьКоманду()

// Выполняет метод объекта по имени. Доступна передача произвольного списка параметров
// Если "Объект" не передан, то выполняется метод глобального контекста
//
// Параметры:
//  Объект  - ВнешнийОбъект, Неопределено - объект-владелец метода, или неопределено(глобальный контекст) 
//  ИмяМетода  - Строка - имя метода, который необходимо выполнить
//  Параметры  - Массив, Неопределено - Массив параметров, для выхова метода
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура                 
//
// Возвращаемое значение:
//   ВнешнийОбъект, Число, Строка, Булево, Неопределено   - Результат выполнения метода объекта
//
Функция ВыполнитьМетодОбъекта(Объект = Null, ИмяМетода, Параметры = Неопределено, Поле = Неопределено) Экспорт 

	//@skip-warning
	Интерпритатор = ИнтерприаторСкриптов(Поле);
	Результат = Неопределено;
	ШаблонМетода = "Результат = Интерпритатор.methodCall(Объект, ""%1"", %2)";
	Выполнить(СтрШаблон(ШаблонМетода,ИмяМетода, СтрокаПередачиПараметровПоМассиву(Параметры)));
	ПроверитьОтвет(Результат);
	Возврат Результат.result;

КонецФункции // ВыполнитьМетодОбъекта()

// Считывает текущее значение объекта js. Если Объект не передан, то считывается свойство глобального контекста
//
// Параметры:
//  Объект  - ВнешнийОбъект, Неопределено - Проверяемый контекст
//  ИмяСвойства  - Строка - Имя проверяемого свойства
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект, Число, Строка, Булево, Неопределено   - Значение свойтсва объекта
//
Функция ЗначениеСвойстваОбъекта(Объект = null, ИмяСвойства, Поле = Неопределено) Экспорт 

	Результат = ИнтерприаторСкриптов(Поле).propEval(Объект, ИмяСвойства);
	ПроверитьОтвет(Результат);
	Возврат Результат.result;

КонецФункции // ЗначениеСвойстваОбъекта()

// Перехватывает сбытие "ПриНажатии" поля формы. Используется для передачи управления из javascript в 1С
//
// Параметры:
//  ДанныеСобытия  - ВнешнийОбъект - Значение переменной "ДанныеСобытия" из события "ПриНажатии" поля формы
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
Процедура ПриНажатии(ДанныеСобытия, Поле = Неопределено) Экспорт 

	ИнтерприаторСкриптов(Поле);	
	Событие = ДанныеСобытия.Event;
	Если Событие.eventData1C <> Неопределено Тогда
		ОбработатьСобытиеИзСкрипта(Событие, Поле);
	КонецЕсли;

КонецПроцедуры // ПриНажатии()

#КонецОбласти

#Область СозданиеОбъектов

// Создаёт новый массив javascript
//
// Параметры:
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на массив js
//
Функция НовыйМассив(Поле = Неопределено)

	Возврат ВыполнитьКоманду("[]", Поле);

КонецФункции // НовыйМассив()

// Создаёт новый object в javasript
//
// Параметры:
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//  
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на объект js
//
Функция НовыйОбъект(Поле = Неопределено)

	Возврат ВыполнитьКоманду("newObject()", Поле);	

КонецФункции // НовыйОбъект()

// Создаёт новый массив и присваивает ему имя. Выполняется в глобальном контексте
//
// Параметры:
//  Имя  - Строка - Имя создаваемого массива
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на массив js
//
Функция НовыйИменованныйМассив(Имя = "", Поле = Неопределено) Экспорт 

	Массив = НовыйМассив(Поле);
	Если Не ПустаяСтрока(Имя) Тогда
		ИменованиеОбъекта(Имя, Массив, Поле);
	КонецЕсли;
	Возврат Массив;

КонецФункции // НовыйИменованныйМассив()

// Создаёт новый object и присваивает ему имя. Выполняется в глобальном контексте
//
// Параметры:
//  Имя  - Строка - Имя создаваемого объекта
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на объект js
//
Функция НовыйИменованныйОбъект(Имя = "", Поле = Неопределено) Экспорт 

	Объект = НовыйОбъект(Поле);
	Если Не ПустаяСтрока(Имя) Тогда
		ИменованиеОбъекта(Имя, Объект, Поле);
	КонецЕсли;
	Возврат Объект;

КонецФункции // НовыйИменованныйОбъект()

// Создаёт новую функцию js.
//
// Параметры:
//  Имя  - Строка - Имя, которое будет присвоено функции
//  ОпределениеМетода  - Строка - текст создаваемой процедуры 
//  	Пример: "function(a) { alert(a)}"
//  Поле  - ПолеФормы - Поле формы, в котором будет создана функция
//
// Возвращаемое значение:
//   ВнешнийОбъект   - ссылка на созданную функцию js
//
Функция НовыйМетод(Имя = "", ОпределениеМетода, Поле = Неопределено) Экспорт 

	Метод = ВыполнитьКоманду(ОпределениеМетода, Поле);
	Если Не ПустаяСтрока(Имя) Тогда
		ИменованиеОбъекта(Имя, Метод);
	КонецЕсли;
	Возврат Метод;

КонецФункции // НовыйМетод()

// Присваивает имя переданному объекту js. Имя присваивается в глобальном контексте
//
// Параметры:
//  Имя  - Строка - Имя, которое будет присвоено объекту
//  Объект  - ВнешнийОбъект - ссылка на объект js, которому необходимо дать имя
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
Процедура ИменованиеОбъекта(Имя, Объект, Поле = Неопределено) Экспорт 

	Результат = ИнтерприаторСкриптов(Поле).giveName(Имя, Объект);
	ПроверитьОтвет(Результат);

КонецПроцедуры // ИменованиеОбъекта()
	
#КонецОбласти

#Область WebSocket

// Создаёт новый объект вебсокет. Добавляет обработчики событий, если они переданы
//
// Параметры:
//  УРЛ  - Строка - строка для подключения к WebSocket серверу
//  Протокол  - Строка - Протокол клиента, используемый при обмене. 
//  Используется в случае если сервер поддерживает несколько протоколов
//  ИмяПеременной  - Строка - имя, которое будет присвоено созданному объекту
//  ОбработчикСоединение  - ОписаниеОповещения - обработчик, который будет вызван при возникновении события "connection"
//  ОбработчикОшибки  - ОписаниеОповещения - обработчик, который будет вызван при возникновении события "error"
//  ОбработчикСообщения  - ОписаниеОповещения - обработчик, который будет вызван при возникновении события "message"
//  ОбработчикЗакрытия  - ОписаниеОповещения - обработчик, который будет вызван при возникновении события "close"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура                                  
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на новый объект js WebSocket
//
Функция НовыйВебСокет(УРЛ, Протокол = "", ИмяПеременной = "", ОбработчикСоединение = Неопределено
		,ОбработчикОшибки = Неопределено, ОбработчикСообщения = Неопределено
		,ОбработчикЗакрытия = Неопределено , Поле = Неопределено) Экспорт 

	Шаблон = ?(Протокол = "", "new WebSocket('%1') %2","new WebSocket('%1' , '%2')");
	Сокет = ВыполнитьКоманду(СтрШаблон(Шаблон, УРЛ, Протокол), Поле);	
	Если Не ПустаяСтрока(ИмяПеременной) Тогда
		ИменованиеОбъекта(ИмяПеременной, Сокет, Поле);
	КонецЕсли;
	Если Не ОбработчикСоединение = Неопределено Тогда
		Если СтатусСокета(Сокет, Поле) = 1 Тогда
			ВыполнитьОбработкуОповещения(ОбработчикСоединение, Истина);
		КонецЕсли;
		СокетДобавитьОбработчикСоединения(Сокет, ОбработчикСоединение, Поле);
	КонецЕсли;
	Если Не ОбработчикОшибки = Неопределено Тогда
		СокетДобавитьОбработчикОшибки(Сокет, ОбработчикОшибки, Поле);
	КонецЕсли;
	Если Не ОбработчикСообщения = Неопределено Тогда
		СокетДобавитьОбработчикСообщения(Сокет, ОбработчикСообщения, Поле);
	КонецЕсли;
	Если Не ОбработчикЗакрытия = Неопределено Тогда
		СокетДобавитьОбработчикЗакрытия(Сокет, ОбработчикЗакрытия, Поле);
	КонецЕсли;
	Возврат Сокет;

КонецФункции // НовыйВебСокет()

// Возвращает строковое представление текущего состояния веб сокета
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Строка   - текущий статус вебсокета
//
Функция СтатусСокета(ВебСокет, Поле = Неопределено) Экспорт 

		Статус = ЗначениеСвойстваОбъекта(ВебСокет, "readyState", Поле);
		Если Статус = 0 Тогда
			Возврат "Соединение";
	   	ИначеЕсли Статус = 1 Тогда
			Возврат "Открыто";
		ИначеЕсли Статус = 2 Тогда
			Возврат "Закрывается";
		ИначеЕсли Статус = 3 Тогда
			Возврат "Закрыто";
		КонецЕсли;

КонецФункции // СтатусСокета()

// Закрывает текущее соединение WebSocket
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Неопределено   - Возвращает результат метода WebSocket.close
//
Функция ЗакрытьСокет(ВебСокет, Поле = Неопределено) Экспорт 

	Возврат ВыполнитьМетодОбъекта(ВебСокет, "close");		

КонецФункции // ЗакрытьСокет()

// Посылает данные на сервер
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Данные  - Строка - Сообщение, которое будет отправлено на сервер методом WebSocket.send
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Неопределено   - Возвращает результат метода WebSocket.send
//
Функция СокетПослатьДанные(ВебСокет, Данные = "", Поле = Неопределено) Экспорт 

	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(Данные);
	Возврат ВыполнитьМетодОбъекта(ВебСокет, "send", ПараметрыМетода, Поле);

КонецФункции // СокетПослатьДанные()

// Добавляет подписку на событие "connection" объекта веб сокет.
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Обработчик  - ОписаниеОповещения - процедура, которая будет выполнена при возникновении события "connection"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Неопределено   - 
//
Функция СокетДобавитьОбработчикСоединения(ВебСокет, Обработчик, Поле = Неопределено) Экспорт 
	
	Возврат ДобавитьОбработчикСобытия(ВебСокет, "open", Обработчик, Поле);
	
КонецФункции // СокетДобавитьОбработчикСоединения()

// Добавляет подписку на событие "error" объекта веб сокет.
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Обработчик  - ОписаниеОповещения - процедура, которая будет выполнена при возникновении события "error"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Неопределено   - 
//
Функция СокетДобавитьОбработчикОшибки(ВебСокет, Обработчик, Поле = Неопределено) Экспорт 

	Возврат ДобавитьОбработчикСобытия(ВебСокет, "error", Обработчик, Поле);

КонецФункции // СокетДобавитьОбработчикОшибки()

// Добавляет подписку на событие "message" объекта веб сокет.
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Обработчик  - ОписаниеОповещения - процедура, которая будет выполнена при возникновении события "message"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Неопределено   - 
//
Функция СокетДобавитьОбработчикСообщения(ВебСокет, Обработчик, Поле = Неопределено) Экспорт 

	Возврат ДобавитьОбработчикСобытия(ВебСокет, "message", Обработчик, Поле);

КонецФункции // СокетДобавитьОбработчикСообщения()

// Добавляет подписку на событие "close" объекта веб сокет.
//
// Параметры:
//  ВебСокет  - ВнешнийОбъект - ссылка на объект js с типом WebSocket
//  Обработчик  - ОписаниеОповещения - процедура, которая будет выполнена при возникновении события "close"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Неопределено   - 
//
Функция СокетДобавитьОбработчикЗакрытия(ВебСокет, Обработчик, Поле = Неопределено) Экспорт 

	Возврат ДобавитьОбработчикСобытия(ВебСокет, "close", Обработчик, Поле);

КонецФункции // СокетДобавитьОбработчикЗакрытия()
	
#КонецОбласти

#Область ОбработчикиОжидания

// Добаляет вызов функции в очередь. Будет выполнен через указанное количество милисекунд
//	Добавляет вызов функцией setTimeout 
//	
// Параметры:
//  ОбъектФункцияИлиОпределение  - ВнешнийОбъект, Строка - сслыка на функцию или строка
//  	, в результате вычисления которого получит ссылку на объект функции (ВнешнийОбъект)
//  Параметры  - Массив, Неопределено - Параметры функции, с которыми будет вызвана функция
//  Таймаут  - Число - через сколько милисекунд будет вызвана функция
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Число   - Идентификатор добавленного таймаута
//
Функция ДобавитьОбработчикОжиданияВнутр(ОбъектФункцияИлиОпределение, Параметры = Неопределено
	, Таймаут = 0, Поле = Неопределено) Экспорт 

	Если ТипЗнч(ОбъектФункцияИлиОпределение) = Тип("Строка") Тогда
		ОбъектФункцияИлиОпределение = НовыйМетод(,ОбъектФункцияИлиОпределение, Поле);
	КонецЕсли;
	Если Не ТипЗнч(ОбъектФункцияИлиОпределение) = Тип("ВнешнийОбъект") Тогда
		ВызватьИсключение "Ожидается внешний объект сооветствующий функции или определение анонимной функции";
	КонецЕсли;
	
	МенеджерОжиданий = ВыполнитьКоманду("timerManager", Поле);
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ОбъектФункцияИлиОпределение);
	ПараметрыМетода.Добавить(Таймаут);
	Если Параметры <> Неопределено И Параметры.Количество() Тогда
		Для Каждого текПараметр Из Параметры Цикл
			ПараметрыМетода.Добавить(текПараметр);
		КонецЦикла;
	КонецЕсли;
	Возврат ВыполнитьМетодОбъекта(МенеджерОжиданий, "addTimer", ПараметрыМетода, Поле);   
	
КонецФункции // ДобавитьОбработчикОжиданияВнутр()

// Возвращаем массив (js) активных обработчиков ожидания. 
//
// Параметры:
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на массив javascript содержащий идентификаторы активных обработчиков ожиданий.
//
Функция ПолучитьАктивныеОбработчикиОжиданияВнутр(Поле = Неопределено) Экспорт 

	Возврат ВыполнитьКоманду("timerManager.getTimers()", Поле);

КонецФункции // ПолучитьАктивныеОбработчикиОжиданияВнутр()

// Добавляет вызов функции в очередь. Будет вызываться каждые {Таймаут} милисекунд
//	Добавляет вызов функцией setInterval 
//
// Параметры:
//  ОбъектФункцияИлиОпределение  - ВнешнийОбъект, Строка - сслыка на функцию или строка
//  	, в результате вычисления которого получит ссылку на объект функции (ВнешнийОбъект)
//  Параметры  - Массив, Неопределено - Параметры функции, с которыми будет вызвана функция
//  Таймаут  - Число - через сколько милисекунд будет вызвана функция
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Число   - Идентификатор добавленного "интервала"
//
Функция ДобавитьОбработчикПовторенияВнутр(ОбъектФункцияИлиОпределение, Параметры = Неопределено
	, Таймаут = 0, Поле = Неопределено) Экспорт 

	Если ТипЗнч(ОбъектФункцияИлиОпределение) = Тип("Строка") Тогда
		ОбъектФункцияИлиОпределение = НовыйМетод(,ОбъектФункцияИлиОпределение, Поле);
	КонецЕсли;
	Если Не ТипЗнч(ОбъектФункцияИлиОпределение) = Тип("ВнешнийОбъект") Тогда
		ВызватьИсключение "Ожидается внешний объект сооветствующий функции или определение анонимной функции";
	КонецЕсли;
	
	МенеджерОжиданий = ВыполнитьКоманду("timerManager", Поле);
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ОбъектФункцияИлиОпределение);
	ПараметрыМетода.Добавить(Таймаут);
	Если Параметры <> Неопределено И Параметры.Количество() Тогда
		Для Каждого текПараметр Из Параметры Цикл
			ПараметрыМетода.Добавить(текПараметр);
		КонецЦикла;
	КонецЕсли;
	Возврат ВыполнитьМетодОбъекта(МенеджерОжиданий, "addInterval", ПараметрыМетода, Поле); 	

КонецФункции // ДобавитьОбработчикПовторенияВнутр()

// Возвращаем массив (js) активных "интервалов"
//
// Параметры:
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на массив javascript содержащий идентификаторы активных "интервалов".
//
Функция ПолучитьАктивныеОбработчикиПовторенияВнутр(Поле = Неопределено) Экспорт 

	Возврат ВыполнитьКоманду("timerManager.getIntervals()", Поле);

КонецФункции // ПолучитьАктивныеОбработчикиПовторенияВнутр()

// Добавляет подписку к переданному объекту
//
// Параметры:
//  ОбъектИлиКодПолученияОбъекта  - ВнешнийОбъект, Строка - Ссылка на объект подписки, или выражение,
//  	которое вернёт ссылку на объект подписки
//  МетодИлиОпределениеМетода  - ВнешнийОбъект, Строка - Ссылка на метод, или выражение
//  ТипСобытия  - Строка - Тип события, на которое будет добавлена подписка
//  ИспользоватьЗахват  - Булево - "useCapture"
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//                 
// Возвращаемое значение:
//   Неопределено   - 
//
Функция ДобавитьПодпискуНаСобытияВнутр(ОбъектИлиКодПолученияОбъекта, МетодИлиОпределениеМетода
	, ТипСобытия = "click", ИспользоватьЗахват = Ложь, Поле = Неопределено) Экспорт 

	Если ТипЗнч(ОбъектИлиКодПолученияОбъекта) = Тип("Строка") Тогда
		ОбъектИлиКодПолученияОбъекта = ВыполнитьКоманду(ОбъектИлиКодПолученияОбъекта, Поле);
	КонецЕсли;
	Если Не ТипЗнч(ОбъектИлиКодПолученияОбъекта) = Тип("ВнешнийОбъект") Тогда
		ВызватьИсключение "Ожидается внешний объект или определение получения элемента html";
	КонецЕсли;
	
	Если ТипЗнч(МетодИлиОпределениеМетода) = Тип("Строка") Тогда
		МетодИлиОпределениеМетода = ВыполнитьКоманду(МетодИлиОпределениеМетода, Поле);
	КонецЕсли;
	Если Не ТипЗнч(МетодИлиОпределениеМетода) = Тип("ВнешнийОбъект") Тогда
		ВызватьИсключение "Ожидается внешний объект или определение получения элемента html";
	КонецЕсли;
	
	МенеджерСобытий = ВыполнитьКоманду("eventManager", Поле);
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ОбъектИлиКодПолученияОбъекта);
	ПараметрыМетода.Добавить(ТипСобытия);
	ПараметрыМетода.Добавить(МетодИлиОпределениеМетода);
	ПараметрыМетода.Добавить(ИспользоватьЗахват);
	Возврат ВыполнитьМетодОбъекта(МенеджерСобытий, "addEventListener", ПараметрыМетода, Поле);

КонецФункции // ДобавитьПодпискуНаСобытияВнутр()

// Возвращаем массив (js) активных подписок на события переданного объекта 
//
// Параметры:
//  Объект  - ВнешнийОбъект - Ссылка на объект js
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на массив javascript содержащий подписки на события переданного объекта
//
Функция ПолучитьАктивныеПодпискиНаСобытияВнутр(Объект = Неопределено, Поле = Неопределено) Экспорт 

	Результат = ИнтерприаторСкриптов(Поле).eventManager.getEventListeners(Объект);			
	ПроверитьОтвет(Результат);
	Возврат Результат.result;
	
КонецФункции // ПолучитьАктивныеПодпискиНаСобытияВнутр()
	
#КонецОбласти

#Область СлужебныеФункции

// Возвращает ссылку на объект window, в котором доступны метода глобального контекста
//
// Параметры:
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//  Если поле не передано, то будет использовано поле по умолчанию. 
//
// Возвращаемое значение:
//   ВнешнийОбъект   - Ссылка на объект window
//
Функция ИнтерприаторСкриптов(Знач Поле = Неопределено) Экспорт 

	Поле = ПолучитьПолеХТМЛ(Поле);
	Контекст = Поле.Документ.defaultView;
	Если Контекст = Неопределено Тогда
		Контекст = Поле.Документ.parentWindow;	
	КонецЕсли;
	Возврат Контекст;

КонецФункции // КонтекстВыполнения()

// Возвращает описание доступного контекста переданной области видимости (объекта)
//
// Параметры:
//  ОбластьВидимости  - ВнешнийОбъект, Неопределено - Исследуемая область видимости
//  Обновить  - Булево - Если Ложь, то доступный контекст будет получен из кэша. Иначе будет прочитан.
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
// Возвращаемое значение:
//   Соответствие   - Описание доступного контекста
//
//@skip-warning
Функция ПолучитьКонтекст(ОбластьВидимости = Null, Обновить = Ложь, Поле = Неопределено) Экспорт 
		
	ИнтерприаторСкриптов(Поле);
	Кэш = пс_ПараметрыПриложения[Поле];
	Если Кэш = Неопределено Тогда
		Кэш = Новый Соответствие;
	КонецЕсли;
	Контекст = Кэш.Получить(ОбластьВидимости);
	Если Контекст = Неопределено Тогда
		Контекст = Новый Соответствие;
	КонецЕсли;
	#Если Не ВебКлиент Тогда
	Если Не Контекст.Количество() Или Обновить Тогда
		Контекст.Очистить();
		РезультатВыполненияСкрипта = ИнтерприаторСкриптов(Поле).getContext(ОбластьВидимости);
		Если РезультатВыполненияСкрипта.error <> Неопределено Тогда
			ВызватьИсключение СтрШаблон("{%1, %2} %3",РезультатВыполненияСкрипта.error.line, РезультатВыполненияСкрипта.error.column, РезультатВыполненияСкрипта.error.description);
		КонецЕсли;
		Чтение = Новый ЧтениеJSON;
		Чтение.УстановитьСтроку(РезультатВыполненияСкрипта.result);
		РезультатДесериализации = ПрочитатьJSON(Чтение, Ложь);
		Для Каждого текИмя Из РезультатДесериализации Цикл
			Если Не ЗначениеЗаполнено(ОбластьВидимости) Тогда
				текИмя.Вставить("Значение", ИнтерприаторСкриптов(Поле).Eval(текИмя.name).result);
			Иначе
				текИмя.Вставить("Значение", текИмя.value);
			КонецЕсли;
			Контекст.Вставить(текИмя.name, текИмя);	
		КонецЦикла;
		Кэш.Вставить(ОбластьВидимости, Контекст);
		пс_ПараметрыПриложения.Вставить(Поле, Кэш);
	КонецЕсли;
	#КонецЕсли
	Возврат Контекст;

КонецФункции // ПолучитьКонтекст()

// Обработчик событий javascript 
//
// Параметры:
//  Событие  - ВнешнийОбъект - Ссылка на событие.
//  Поле  - ПолеФормы - Поле формы, в котором будет выполнена процедура
//
Функция  ОбработатьСобытиеИзСкрипта(Событие, Поле)

	Данные = Событие.eventData1C;
	Если Данные.event = "showMessage" Тогда
		Сообщить(Данные.params);
	ИначеЕсли Данные.event = "trowError" Тогда
		ВызватьИсключение Данные.params;
	ИначеЕсли Данные.event = "eventLog" Тогда
//		СтруктураСобытия = ПолучитьКонтекст(Данные.params, Истина, Поле);
//		пс_СкриптыВызовСервера.ОбработкаСобытияЗаписьЖурналаРегистрации(СтруктураСобытия);
	ИначеЕсли Данные.event = "callback1C" Тогда	
		Обработчик = ПолучитьКешПоля(КлючКешОбработчикаОповещения(Данные.params.idHandler), Поле);
		ВыполнитьОбработкуОповещения(Обработчик, Данные.params);
	//ИначеЕсли пс_ОбработкаСобытийСкриптовПереопределяемый.ОбработатьСобытие(Событие, Поле) Тогда	
//	Иначе
//		Возврат ПользовательскаяОбработкаСобытий(Событие, Поле);
	КонецЕсли;
	Возврат Неопределено;

КонецФункции // ОбработатьСобытиеИзСкрипта()

// Проверяет ответ js. Если вернулась ошибка, то вызывает исключение с текстом
//
// Параметры:
//  Объект  - ВнешнийОбъект - Объект, возвращаемый из js, для перехвала исключений
//
Процедура ПроверитьОтвет(Объект)

	Если Объект.error <> Неопределено Тогда
		ВызватьИсключение СтрШаблон("{%1, %2} %3",Объект.error.line, Объект.error.column, Объект.error.description);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьОтвет()

// Возвращает строку, для передали параметров в вычисляемый метод с произвольным набором параметров
//
// Параметры:
//  МассивПараметров  - Массив, Неопределено - 
//
// Возвращаемое значение:
//   Строка   - Строка для вызова метода и передачи в него  переметров
//
//@skip-warning
Функция СтрокаПередачиПараметровПоМассиву(МассивПараметров)

	ПараметрыСтрока = "";
	Если МассивПараметров <> Неопределено И МассивПараметров.Количество() > 0 Тогда
		Для Индекс = 0 По МассивПараметров.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + Индекс + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	Возврат ПараметрыСтрока;

КонецФункции // СтрокаПередачиПараметровПоМассиву()

// Возвращает форму владелец переданного элемента
//
// Параметры:
//  Поле  - ПолеФормы  
//
// Возвращаемое значение:
//   ФормаКлиентскогоПриложения   
//
Функция НайтиФормуЭлемента(Поле)

	Родитель = Поле.Родитель;
	Если ТипЗнч(Родитель) = Тип("ФормаКлиентскогоПриложения") Тогда
		Возврат Родитель;
	Иначе
		Возврат НайтиФормуЭлемента(Родитель);
	КонецЕсли;

КонецФункции // НайтиФормуЭлемента()

// Возвращает поле хтмл по умолчанию, если поле не передано.
//
// Параметры:
//  Поле  - ПолеФормы - Поле формы с видом поле хтмл
//
// Возвращаемое значение:
//   ПолеФормы   - 
//
Функция ПолучитьПолеХТМЛ(Поле = Неопределено)
	Если Поле = Неопределено Тогда
		Поле = ПолучитьПолеХТМЛПоУмолчанию();
		Если Поле = Неопределено Тогда
			ВызватьИсключение "Поле документа HTML не удалось определить";
		КонецЕсли;
	КонецЕсли;
	Возврат Поле;
КонецФункции

// Возвращает ключ обработчика для сохранения кэша
//
// Параметры:
//  ИД  - Строка - Уникальный идентификатор обработчика оповещения
//
// Возвращаемое значение:
//   Строка   - Ключ обработчика
//
Функция КлючКешОбработчикаОповещения(ИД)
	Возврат СтрШаблон("ОбработчикиОповещения.%1", ИД);
КонецФункции

// Добавляет подписку на события javascript, подключает к событию обработчик оповещения 1С
//
// Параметры:
//  ОбъектОтслеживания  - ВнешнийОбъект - Ссылка на объект прослушки
//  Событие  - Строка - событие js, на которое добавляется подписка
//  Обработчик  - ОписаниеОповещения - Обработчик обработки события
//  Поле  - ПолеФормы - Поле формы с видом поле хтмл 
//                 
// Возвращаемое значение:
//   Неопределено - 
//
Функция ДобавитьОбработчикСобытия(ОбъектОтслеживания, Событие, Обработчик, Поле = Неопределено) Экспорт
	ИДОбработчика = Новый УникальныйИдентификатор;
	
	ИДДляКэш = КлючКешОбработчикаОповещения(ИДОбработчика);
	ПоместитьКешПоля(ИДДляКэш, Обработчик, Поле);
	ШаблонМетода = "(eventData) => { eventData.idHandler = '%1'; return sendEvent('callback1C', eventData); }";
	Скрипт = ВыполнитьКоманду(СтрШаблон(ШаблонМетода,ИДОбработчика), Поле);
	Возврат ДобавитьПодпискуНаСобытияВнутр(ОбъектОтслеживания, Скрипт, Событие,,Поле);	

КонецФункции // ДобавитьОбработчикСобытия()




#КонецОбласти


