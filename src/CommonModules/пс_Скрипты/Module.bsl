
#Область ПрограммныйИнтерфейс

// Подключает скрипт к хтмл Полю по адресу временного хранилища
//
// Параметры:
//  Поле  					- ПолеФормы - Поле формы с видом ПолеHTMLДокумента
//	ДополнительныеПараметры	- Структура 
//
Процедура ПодключитьСрипт(АдесФайла, Поле) Экспорт 

	МассивАдресов = Новый Массив;
	МассивАдресов.Добавить(СтруктураПодключаемогоФайла(АдесФайла));
	ПодключитьФайлы(МассивАдресов, Поле);
		
КонецПроцедуры // ПодключитьСрипт()

// Подключает основное расширение скриптов, и все настроенные файлы для переданного поля
//
// Параметры:
//  Поле	- ПолеФормы - Поле формы с видом ПолеHTMLДокумента
//
Процедура ПодключитьРасширенныеСкрипты(Поле) Экспорт 

	МассивАдресов = Новый Массив;
	АдресОсновногоСкрипта = пс_СкриптыСерверПовтИсп.АдресОсновногоРасширенияСкриптов();
	МассивАдресов.Добавить(СтруктураПодключаемогоФайла(АдресОсновногоСкрипта));
	ПриОпределенииПодключаемыхФайлов(МассивАдресов, Поле);
	ПодключитьФайлы(МассивАдресов, Поле);
		
КонецПроцедуры // ПодключитьСкрипты()

Процедура ИнициализироватьРедакторКода(Поле) Экспорт
	
	//@skip-warning
	АдресРедактора = пс_СкриптыВызовСервера.ПолучитьИзСерверногоКэша("АдресРедактораКода");
	//@skip-warning
	Форма = НайтиФормуЭлемента(Поле);
	Выполнить(СтрШаблон(
	"Форма.%1 = АдресРедактора", Поле.ПутьКДанным));
	 
КонецПроцедуры

#КонецОбласти

#Область HTML

// Парсит хтмл документ в ДокументHTML
//
// Параметры:
//  текстХТМЛ  - Строка - текст хтмл документа
//
// Возвращаемое значение:
//   ДокументHTML   - распарсенный документ ХТМЛ
//
Функция ТекстВДокументХТМЛ(текстХТМЛ)

	Чтение = Новый ЧтениеHTML;
	Чтение.УстановитьСтроку(текстХТМЛ);
	Построитель = Новый ПостроительDOM;
	ДокументХТМЛ = Построитель.Прочитать(Чтение);
	Чтение.Закрыть();
	Возврат ДокументХТМЛ;

КонецФункции // ТекстВДокументХТМЛ()

// Преобразует ДокументHTML в строку
//
// Параметры:
//  Документ  - ДокументHTML - Документ, который необходимо преобразовать в строку
//
// Возвращаемое значение:
//   Строка   - <описание возвращаемого значения>
//
//@skip-warning
Функция ДокументХТМЛВТекст(Документ)

	ЗаписьХТМЛ = Новый ЗаписьHTML;
	ЗаписьХТМЛ.УстановитьСтроку();
	ЗаписьДОМ = Новый ЗаписьDOM;
	ЗаписьДОМ.КонфигурацияDOM.УстановитьПараметр("discard-default-content", Истина);
	ЗаписьДОМ.Записать(Документ, ЗаписьХТМЛ);
	ХТМЛТекст = ЗаписьХТМЛ.Закрыть();
	Возврат СтрЗаменить(ХТМЛТекст, "<!DOCTYPE html PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">", "<!DOCTYPE html>");

КонецФункции // ДокументХТМЛВТекст()
	
#КонецОбласти

#Область ПодключаемыеФайлы

// Ищет в настройках все файлы, которые необходимо подключить к Полю и добавляет их адреса в массив
// 
// Параметры:
// 	МассивАдресов - Массив - Выходной параметр с массивом адресов подключаемых файлов
// 	Поле - ПолеФормы - Поле формы, к которому подключаем файлы
//@skip-warning
Процедура ПриОпределенииПодключаемыхФайлов(МассивАдресов, Поле)
	
КонецПроцедуры

// Добавляет элементы ХТМЛ документа, переданные в параметре МассивПодключаемыхФайлов
// 
// Параметры:
// 	МассивПодключаемыхФайлов - Массив - см. СтруктураПодключаемогоФайла
// 	Поле - ПолеФормы - Поле формы, в котором производится операция
Процедура ПодключитьФайлы(Знач МассивПодключаемыхФайлов, Знач Поле) 

	//@skip-warning
	Форма = НайтиФормуЭлемента(Поле);
	
	ТекстСтраницы = Вычислить("Форма." + Поле.ПутьКДанным);
	Если ПустаяСтрока(ТекстСтраницы) Тогда
		Документ = НовыйДокументХТМЛ();
	Иначе
		Документ = ТекстВДокументХТМЛ(ТекстСтраницы);	
	КонецЕсли;
	
	Для Каждого текФайл Из МассивПодключаемыхФайлов Цикл
		ВыполнитьПодключениеФайла(Документ, текФайл);
	КонецЦикла;
	
	Выполнить("Форма." + Поле.ПутьКДанным + " = ДокументХТМЛВТекст(Документ);");	
	
КонецПроцедуры // ПодключитьФайлы()

// см. ПодключитьФайлы 
// 
// Параметры:
// 	Документ - ДокументHTML - 
// 	СтруктураПодключения - Структура - 
Процедура ВыполнитьПодключениеФайла(Документ, СтруктураПодключения)	
	ПодключаемыйЭлемент	= Документ.СоздатьЭлемент(СтруктураПодключения.ИмяТега);
	Для Каждого текАтрибут Из СтруктураПодключения.Атрибуты Цикл
		ПодключаемыйЭлемент.УстановитьАтрибут(текАтрибут.Ключ, текАтрибут.Значение);	
	КонецЦикла;
	НайденныеУзлы = Документ.ПолучитьЭлементыПоИмени("HEAD");
	Если СтруктураПодключения.ПодключатьВЗаголовке
		И НайденныеУзлы.Количество() Тогда	
		Родитель = НайденныеУзлы.Элемент(0);
	Иначе
		Родитель = Документ.ЭлементДокумента;
	КонецЕсли;
	Родитель.ДобавитьДочерний(ПодключаемыйЭлемент);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает форму владелец переданного элемента
//
// Параметры:
//  Поле  - ПолеФормы  
//
// Возвращаемое значение:
//   ФормаКлиентскогоПриложения   
//
Функция НайтиФормуЭлемента(Поле) Экспорт

	Родитель = Поле.Родитель;
	Если ТипЗнч(Родитель) = Тип("ФормаКлиентскогоПриложения") Тогда
		Возврат Родитель;
	Иначе
		Возврат НайтиФормуЭлемента(Родитель);
	КонецЕсли;

КонецФункции // НайтиФормуЭлемента()

// Возвращает новый пустой Документ HTML. Добавляет теги HEAD и BODY
//
// Возвращаемое значение:
//   ДокументHTML  - 
//
Функция НовыйДокументХТМЛ()

	Документ = Новый ДокументHTML; 
	УзелХЕАД = Документ.СоздатьЭлемент("HEAD");	
	УзелБАДИ = Документ.СоздатьЭлемент("BODY");
	Документ.ЭлементДокумента.ДобавитьДочерний(УзелХЕАД);
	Документ.ЭлементДокумента.ДобавитьДочерний(УзелБАДИ);			
	Возврат Документ;

КонецФункции // НовыйДокументХТМЛ()

// Возвращает структуру настроек, для подключения файла к документу
// 
// Параметры:
// 	АдресФайла - Строка - Описание
// Возвращаемое значение:
// 	Структура - Описание
Функция СтруктураПодключаемогоФайла(АдресФайла = "",ИмяТега = "script", ПодключатьВЗаголовке = Ложь)
	Результат = Новый Структура;
	Результат.Вставить("ПодключатьВЗаголовке", ПодключатьВЗаголовке);
	Результат.Вставить("ИмяТега", ИмяТега);
	Результат.Вставить("Текст", "");
	Результат.Вставить("Атрибуты", Новый Структура);
	Если Не ПустаяСтрока(АдресФайла) Тогда
		Результат.Атрибуты.Вставить("src", АдресФайла);
	КонецЕсли;	
	Возврат Результат;
КонецФункции



#КонецОбласти
