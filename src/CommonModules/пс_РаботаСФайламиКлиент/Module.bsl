
#Область ПрограммныйИнтерфейс

// Показывает форму выбора файла.
// 
// Параметры:
// 	ОбработчикРезультата - ОписаниеОповещения
// 	ИдентификаторФормы - УникальныйИдентификатор
// 	Фильтр - Строка
// 	Заголовок - Неопределено
// 	МножественныйВыбор - Булево
Процедура ВыбратьФайлы(ОбработчикРезультата, ИдентификаторФормы
	, Фильтр = "", Заголовок = Неопределено, МножественныйВыбор = Ложь) Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ИдентификаторФормы",   	ИдентификаторФормы);
	Параметры.Вставить("Фильтр",               	Фильтр);
	Параметры.Вставить("Заголовок",             Заголовок);
	Параметры.Вставить("МножественныйВыбор",	МножественныйВыбор);
	Параметры.Вставить("ОбработчикРезультата", 	ОбработчикРезультата);
	
	Если ЭтоПлатформа15Плюс() Тогда
		ВыбратьФайлыПлатформа15Плюс(Параметры); 
	Иначе
		ВыбратьФайлыПлатформа15Минус(Параметры);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Платформа15Плюс

// Открывает диалог выбора файла при использовании 15 и более новой версии платформы
// 
// Параметры:
// 	Параметры - Структура - Описание:
// * МножественныйВыбор - Булево -
// * Заголовок - Строка, Неопределено -
// * Фильтр - Строка -
Процедура ВыбратьФайлыПлатформа15Плюс(Параметры)
	
	ФормаПрогресса = ОткрытьФорму("ОбщаяФорма.пс_ФормаПрогрессаЗагрузкиФайлов"
		, Новый Структура("СоставнойПрогресс", Параметры.МножественныйВыбор));
	ФормаПрогресса.Закрыть();
	Параметры.Вставить("ФормаПрогресса", ФормаПрогресса);
	ОписаниеОповещенияОЗавершении
		= Новый ОписаниеОповещения(
			"ПоместитьФайлыЗавершение"
			, ЭтотОбъект
			, Параметры);
	ОписаниеОповещенияОХодеВыполнения 
		= Новый ОписаниеОповещения(
			"ОповещениеОХодеВыполненияПомещенияФайлов"
			, ЭтотОбъект
			, ФормаПрогресса);
	ОписаниеОповещенияПередНачалом 
		= Новый ОписаниеОповещения("ПередНачаломПомещенияФайлов"
			, ЭтотОбъект
			, ФормаПрогресса);
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов();
	ПараметрыДиалога.МножественныйВыбор = Параметры.МножественныйВыбор;
	ПараметрыДиалога.Фильтр = Параметры.Фильтр;
	ПараметрыДиалога.Заголовок = Параметры.Заголовок;
	ИДФормы = Параметры.ИдентификаторФормы;
	// чтобы модуль скомпилировался в платформе менее 15
	НачатьПомещениеФайловНаСервер(ОписаниеОповещенияОЗавершении
		, ОписаниеОповещенияОХодеВыполнения, ОписаниеОповещенияПередНачалом
		, ПараметрыДиалога, ИДФормы);
КонецПроцедуры

// Процедура отображает процесс помещения файлов во временное хранилище
// 
// Параметры:
// 	ПомещаемыйФайл - СсылкаНаФайл
// 	Помещено - Число
// 	ОтказОтПомещенияФайла - Булево
// 	ПомещеноВсего - Число
// 	ОтказОтПомещенияВсехФайлов - Булево
// 	ДополнительныеПараметры
Процедура ОповещениеОХодеВыполненияПомещенияФайлов(ПомещаемыйФайл, Помещено
		, ОтказОтПомещенияФайла, ПомещеноВсего
		, ОтказОтПомещенияВсехФайлов, ФормаПрогресса) Экспорт
	Если Не ФормаПрогресса.Открыта() Тогда
		ОтказОтПомещенияВсехФайлов = Истина;
		Возврат;
	КонецЕсли;	
	ОтказОтПомещенияФайла = ФормаПрогресса.Отменено;
	ОтказОтПомещенияВсехФайлов = ФормаПрогресса.ОтмененоСоставной;
	ФормаПрогресса.ОбновитьПрогресс(Помещено, СтрШаблон("Загружается файл %1", ПомещаемыйФайл.Имя));
	ФормаПрогресса.ОбновитьСоставнойПрогресс(ПомещеноВсего);	
КонецПроцедуры

// Выполняется перед началом помещения файлов во временное хранилище
// 
// Параметры:
// 	ПомещаемыеФайлы - Массив - Массив элементов типа СсылкаНаФайл, готовых к помещению во временное хранилище.
// 	ОтказОтПомещенияВсехФайлов - Булево - Признак отказа от дальнейшего помещения всех файлов
// 	ДополнительныеПараметры
Процедура ПередНачаломПомещенияФайлов(ПомещаемыеФайлы, ОтказОтПомещенияВсехФайлов
	, ФормаПрогресса) Экспорт
	ФормаПрогресса.Открыть();
КонецПроцедуры

#КонецОбласти

#Область Платформа15Минус

// Открывает диалог выбора файла при использовании 14 и более старой версии платформы
// 
// Параметры:
// 	Параметры - Структура - Описание:
// * ИдентификаторФормы - УникальныйИдентификатор
// * ОбработчикРезультата - ОписаниеОповещения
// * МножественныйВыбор - Булево -
// * Заголовок - Неопределено -
// * Фильтр - Строка -
Процедура ВыбратьФайлыПлатформа15Минус(Параметры)
	Описание = Новый ОписаниеОповещения(
		"ВыбратьФайлыПослеУстановкиРасширения"
		, ЭтотОбъект
		, Параметры);
	ПоказатьВопросУстановкиРасширенияРаботыСФайлами(Описание);	
КонецПроцедуры

// Подключает расширение работы с файлами, для необзодимости
// 
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Описание
Процедура ПоказатьВопросУстановкиРасширенияРаботыСФайлами(ОписаниеОповещения)
	Если Не КлиентПоддерживаетСинхронныеВызовы() Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь);
		Возврат;
	КонецЕсли;
	#Если Не ВебКлиент Тогда
	// В мобильном, тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	Возврат;
	#КонецЕсли
	
	// TODO: сделать поддержку вебклиента	
	
КонецПроцедуры

// Проверяет, доступны ли синфронные вызовы
// 
// Возвращаемое значение:
// 	Булево - Описание
Функция КлиентПоддерживаетСинхронныеВызовы()
	
#Если ВебКлиент Тогда
	// В Chrome и Firefox синхронные методы не поддерживаются.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИнформацияПрограммыМассив = СтрРазделить(СистемнаяИнформация.ИнформацияПрограммыПросмотра, " ", Ложь);
	
	Для Каждого ИнформацияПрограммы Из ИнформацияПрограммыМассив Цикл
		Если СтрНайти(ИнформацияПрограммы, "Chrome") > 0 ИЛИ СтрНайти(ИнформацияПрограммы, "Firefox") > 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
#КонецЕсли
	
	Возврат Истина;
	
КонецФункции

// Показывает диалог выбора файлов с переданными параметрами
// 
// Параметры:
// 	Подключено - Булево
// 	ДополнительныеПараметры
Процедура ВыбратьФайлыПослеУстановкиРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Не Подключено Тогда
		Возврат;	
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ПоместитьФайлыНачало", ЭтотОбъект, ДополнительныеПараметры);
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр = ДополнительныеПараметры.Фильтр;
	Диалог.МножественныйВыбор = ДополнительныеПараметры.МножественныйВыбор;
	Если ДополнительныеПараметры.Свойство("ЗаголовокДиалога") Тогда
		Диалог.Заголовок = ДополнительныеПараметры.ЗаголовокДиалога;
	КонецЕсли;
	Диалог.Показать(Описание);
	
КонецПроцедуры

// Начинает помещение файлов во временное хранилище после выбора диалогом.
// 
// Параметры:
// 	ВыбранныеФайлы - Массив, Неопределено
// 	ДополнительныеПараметры
Процедура ПоместитьФайлыНачало(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПомещаемыеФайлы = Новый Массив;
	Для Каждого текВыбранныйФайл Из ВыбранныеФайлы Цикл
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(текВыбранныйФайл));	
	КонецЦикла;
	Описание = Новый ОписаниеОповещения("ПоместитьФайлыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(Описание, ПомещаемыеФайлы,,, ДополнительныеПараметры.ИдентификаторФормы);	
КонецПроцедуры

// Приводит помещённые файлы к виду ОписаниеПомещенногоФайла, добавленный в 15 версии 
// 
// Параметры:
// 	ПомещенныеФайлы - Массив, Неопределено
// 	ДополнительныеПараметры
Процедура ПоместитьФайлыЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ДополнительныеПараметры.Свойство("ФормаПрогресса")
		И ДополнительныеПараметры.ФормаПрогресса.Открыта() Тогда
		ДополнительныеПараметры.ФормаПрогресса.Закрыть();	
	КонецЕсли;
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если ПомещенныеФайлы.Количество() И ТипЗнч(ПомещенныеФайлы[0]) = Тип("ОписаниеПереданногоФайла") Тогда
		РезультатПомещённыеФайлы = Новый Массив;
		Для Каждого текПомещённыйФайл Из ПомещенныеФайлы Цикл
			Файл = Новый Файл(текПомещённыйФайл.ПолноеИмя);
			СсылкаНаФайл = Новый Структура;
			СсылкаНаФайл.Вставить("ИдентификаторФайла", текПомещённыйФайл.ИдентификаторФайла);
			СсылкаНаФайл.Вставить("Имя", текПомещённыйФайл.Имя);
			СсылкаНаФайл.Вставить("Расширение", Файл.Расширение);
			СсылкаНаФайл.Вставить("Файл", Файл);
			ПомещённыйФайл = Новый Структура;
			ПомещённыйФайл.Вставить("Адрес", текПомещённыйФайл.Хранение);
			ПомещённыйФайл.Вставить("ПомещениеФайлаОтменено", Ложь);
			ПомещённыйФайл.Вставить("СсылкаНаФайл", СсылкаНаФайл);
			РезультатПомещённыеФайлы.Добавить(ПомещённыйФайл);
		КонецЦикла;
	Иначе
		РезультатПомещённыеФайлы = ПомещенныеФайлы;	
	КонецЕсли;
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОбработчикРезультата, РезультатПомещённыеФайлы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункции

// Возвращает Истина, если версия платформы больше или равна 8.3.15
// 
// Возвращаемое значение:
// 	Булево
Функция ЭтоПлатформа15Плюс()
	СистемнаяИнформация = Новый СистемнаяИнформация();
	МассивВерсий = СтрРазделить(СистемнаяИнформация.ВерсияПриложения, ".");
	Мажорная = МассивВерсий.Получить(1);
	Минорная = МассивВерсий.ПОлучить(2);
	Возврат Мажорная = "3" И Число(Минорная) >= 15;
КонецФункции




#КонецОбласти
