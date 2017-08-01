//
//  asyncUdpSocket.h
//  ttttttt
//
//  Created by Jian Huang on 23/11/2016.
//  Copyright © 2016 Jian Huang. All rights reserved.
//

#ifndef asyncUdpSocket_h
#define asyncUdpSocket_h

#include <iostream>
#include <string>
#include <boost/bind.hpp>
#include <boost/asio.hpp>
#include <boost/asio/ssl.hpp>
#include <boost/signals2/signal.hpp>

#include <sstream>
#include <string>
#include <boost/lexical_cast.hpp>


#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "HttpStatisticsNative", __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, "HttpStatisticsNative", __VA_ARGS__)
#include "logger/ystCommonThread.h"
#else
#include "ystCommonThread.h"
#endif

using boost::asio::ip::udp;
using boost::asio::ip::tcp;

int post(const string& host, const string& port, const string& page, const string& data, string& reponse_data)
{
    unsigned int status_code = 0;
    try
    {
        boost::asio::io_service io_service;
        boost::system::error_code ec;
        //如果io_service存在复用的情况
        if(io_service.stopped())
            io_service.reset();

        // 从dns取得域名下的所有ip
        tcp::resolver resolver(io_service);
        tcp::resolver::query query(host, port);
        tcp::resolver::iterator endpoint_iterator = resolver.resolve(query, ec);
        if (ec != 0) {
            //LOGD("\nERR resolve %s\n", boost::system::system_error(ec).what());
            return -1;
        }
        // 尝试连接到其中的某个ip直到成功
        tcp::socket socket(io_service);
        //socket.set_option(tcp::no_delay(true));
        boost::asio::connect(socket, endpoint_iterator, ec);
        boost::asio::ip::tcp::endpoint endpoint = *endpoint_iterator;
        if (ec != 0) {
            //std::cout << "\nERR " << endpoint << " connect faild:" << boost::system::system_error(ec).what() << "\n";
            return -1;
        } else {
            std::cout << "\nSuccuss " << endpoint << " connected.\n";
        }
        
        // Form the request. We specify the "Connection: close" header so that the
        // server will close the socket after transmitting the response. This will
        // allow us to treat all data up until the EOF as the content.
        boost::asio::streambuf request;
        std::ostream request_stream(&request);
        request_stream << "POST " << page << " HTTP/1.0\r\n";
        request_stream << "Host: " << host << ":" << port << "\r\n";
        request_stream << "Accept: */*\r\n";
        request_stream << "Content-Length: " << data.length() << "\r\n";
        request_stream << "Content-Type: application/x-www-form-urlencoded\r\n";
        request_stream << "Connection: close\r\n\r\n";
        request_stream << data;

        // Send the request.
        boost::asio::write(socket, request, ec);
        if (ec != 0) {
            //LOGD("\nERR write %s\n", boost::system::system_error(ec).what());
            return -1;
        }
        // Read the response status line. The response streambuf will automatically
        // grow to accommodate the entire line. The growth may be limited by passing
        // a maximum size to the streambuf constructor.
        boost::asio::streambuf response;
        boost::asio::read_until(socket, response, "\r\n", ec);
        if (ec != 0) {
            //LOGD("\nERR read_until %s\n", boost::system::system_error(ec).what());
            return -1;
        }
        // Check that response is OK.
        std::istream response_stream(&response);
        std::string http_version;
        response_stream >> http_version;

        response_stream >> status_code;
        std::string status_message;
        std::getline(response_stream, status_message);
        if (!response_stream || http_version.substr(0, 5) != "HTTP/")
        {
            reponse_data = "Invalid response";
            return -2;
        }
        // 如果服务器返回非200都认为有错,不支持301/302等跳转
        if (status_code != 200)
        {
            reponse_data = "Response returned with status code != 200 " ;
            return status_code;
        }

        // 传说中的包头可以读下来了
        std::string header;
        std::vector<string> headers;
        while (std::getline(response_stream, header) && header != "\r")
            headers.push_back(header);

        // 读取所有剩下的数据作为包体
        boost::system::error_code error;
        while (boost::asio::read(socket, response,
                                 boost::asio::transfer_at_least(1), error))
        {
        }

        //响应有数据
        if (response.size())
        {
            std::istream response_stream(&response);
            std::istreambuf_iterator<char> eos;
            reponse_data = string(std::istreambuf_iterator<char>(response_stream), eos);
        }

        if (error != boost::asio::error::eof)
        {
            reponse_data = error.message();
            return -3;
        }
    }
    catch(...)
    {
        //reponse_data = e.what();
        return -4;
    }
    return status_code;
}

bool verify_certificate(bool preverified,
                        boost::asio::ssl::verify_context& ctx)
{
    // The verify callback can be used to check whether the certificate that is
    // being presented is valid for the peer. For example, RFC 2818 describes
    // the steps involved in doing this for HTTPS. Consult the OpenSSL
    // documentation for more details. Note that the callback is called once
    // for each certificate in the certificate chain, starting from the root
    // certificate authority.
    
    // In this example we will simply print the certificate's subject name.
    char subject_name[256];
    X509* cert = X509_STORE_CTX_get_current_cert(ctx.native_handle());
    X509_NAME_oneline(X509_get_subject_name(cert), subject_name, 256);
    std::cout << "Verifying " << subject_name << "\n";
    
    return true;
}

int posts(const string& host, const string& port, const string& page, const string& data, string& reponse_data)
{
    try {
        unsigned int status_code = 0;
        
        using boost::asio::ip::tcp;
        namespace ssl = boost::asio::ssl;
        typedef ssl::stream<tcp::socket> ssl_socket;
        
        // Create a context that uses the default paths for
        // finding CA certificates.
        
        // Open a socket and connect it to the remote host.
        boost::asio::io_service io_service;
        boost::system::error_code ec;
        
        if(io_service.stopped())
            io_service.reset();
        
        
        ssl::context ctx(ssl::context::sslv23);
        ctx.set_default_verify_paths();
        
        ssl_socket socket(io_service, ctx);
        tcp::resolver resolver(io_service);
        
        tcp::resolver::query query(host, port);
        boost::asio::ip::tcp::resolver::iterator iter = resolver.resolve(query);
        boost::asio::ip::tcp::resolver::iterator end; // End marker.
        
        //socket.lowest_layer().set_option(tcp::no_delay(true));
        boost::asio::connect(socket.lowest_layer(), iter, ec);
        boost::asio::ip::tcp::endpoint endpoint = *iter;
        
        if (ec != 0) {
            //std::cout << "\nERR " << endpoint << " connect faild:" << boost::system::system_error(ec).what() << "\n";
            iter ++;
            return -1;
        } else {
            std::cout << "\nSuccuss " << endpoint << " connected.\n";
        }
        
        
        // Perform SSL handshake and verify the remote host's
        // certificate.
        
        socket.set_verify_mode(ssl::verify_peer);
        
        //socket.set_verify_callback(ssl::rfc2818_verification(host));
        //boost::bind(&client::verify_certificate, this, _1, _2)
        socket.set_verify_callback(boost::bind(&verify_certificate, _1, _2));
        
        socket.handshake(ssl_socket::client, ec);
        if (ec != 0) {
            //LOGD("\nERR handshake %s\n", boost::system::system_error(ec).what());
            return -1;
        }
        //boost::asio::connect(socket, endpoint_iterator);

        // Form the request. We specify the "Connection: close" header so that the
        // server will close the socket after transmitting the response. This will
        // allow us to treat all data up until the EOF as the content.
        boost::asio::streambuf request;
        std::ostream request_stream(&request);
        request_stream << "POST " << page << " HTTP/1.1\r\n";
        request_stream << "Host: " << host << ":" << port << "\r\n";
        request_stream << "Accept: */*\r\n";
        request_stream << "Content-Length: " << data.length() << "\r\n";
        //request_stream << "Content-Type: application/x-www-form-urlencoded\r\n";
        request_stream << "Connection: close\r\n\r\n";
        request_stream << data;
  
        // Send the request.
        size_t bytes_transferred = boost::asio::write(socket, request, ec);
        if (ec != 0) {
            //LOGD("\nERR write %s\n", boost::system::system_error(ec).what());
            return -1;
        }
        LOGD("\nwrite bytes_transferred : %zu\n ", bytes_transferred);
        // Read the response status line. The response streambuf will automatically
        // grow to accommodate the entire line. The growth may be limited by passing
        // a maximum size to the streambuf constructor.
        boost::asio::streambuf response;
        bytes_transferred = boost::asio::read_until(socket, response, "\r\n", ec);
        LOGD("\nread_until bytes_transferred : %zu\n ", bytes_transferred);
        if (ec != 0) {
            //LOGD("\nERR read_until %s\n", boost::system::system_error(ec).what());
            return -1;
        }
        // Check that response is OK.
        std::istream response_stream(&response);
        std::string http_version;
        response_stream >> http_version;
        
        response_stream >> status_code;
        std::string status_message;
        std::getline(response_stream, status_message);
        if (!response_stream || http_version.substr(0, 5) != "HTTP/")
        {
            reponse_data = "Invalid response";
            return -2;
        }
        // 如果服务器返回非200都认为有错,不支持301/302等跳转
        if (status_code != 200)
        {
            reponse_data = "Response returned with status code != 200 " ;
            return status_code;
        }
        
        // 传说中的包头可以读下来了
        std::string header;
        std::vector<string> headers;
        while (std::getline(response_stream, header) && header != "\r")
            headers.push_back(header);
        
        // 读取所有剩下的数据作为包体
        boost::system::error_code error;
        while (boost::asio::read(socket, response,
                                 boost::asio::transfer_at_least(1), error))
        {
        }
        
        //响应有数据
        if (response.size())
        {
            std::istream response_stream(&response);
            std::istreambuf_iterator<char> eos;
            reponse_data = string(std::istreambuf_iterator<char>(response_stream), eos);
        }
        
        if (error != boost::asio::error::eof)
        {
            reponse_data = error.message();
            return -3;
        }
        return status_code;
    }
    catch(...)
    {
        //reponse_data = e.what();
        return -4;
    }
    
    
}

int ParseUri( string& sUri, string& sHost, string& nPort, string& sPath )
{
    string sParseUri = sUri;

    if( sParseUri.empty() )
    {
        return -1;
    }

    if( 0 == sParseUri.compare(0, 3, "www") )
    {
        sParseUri = string("http://") + sParseUri;
    }
    
    int isHttps = 0;
    string s = "";
    if (0 == sParseUri.compare(0, 8, "https://")) {
        s = "https://";
        isHttps = 1;
    } else if (0 == sParseUri.compare(0, 7, "http://")){
        s = "http://";
    }
    
    if( s.length() > 0)  //URI
    {

        size_t nPos1 = sParseUri.find('/',s.length());
        if( string::npos != nPos1 )
        {
            sPath = sParseUri.substr(nPos1, sParseUri.length()-nPos1);

            size_t nPos2 = sParseUri.find(":",s.length());
            if( string::npos != nPos2 )
            {
                sHost = sParseUri.substr(s.length(), nPos2-s.length());

                char *endptr;
                errno = 0;
                long nVal = strtol(sParseUri.substr(nPos2+1, nPos1-nPos2+1).c_str(), &endptr, 10);
                if( (ERANGE == errno && (LONG_MAX == nVal || LONG_MIN == nVal )) //underflow or overflow
                   || (errno != 0 && nVal == 0) ) //no digit
                {
                    return -1;
                }
                else
                {

                    nPort = boost::lexical_cast<std::string>(nVal);
                }
            }
            else
            {
                sHost  = sParseUri.substr(s.length(), nPos1-s.length());
                nPort = "80";
            }
        }
        else
        {
            sPath = "/";

            size_t nPos2 = sParseUri.find(':',s.length());
            if( string::npos != nPos2 )
            {
                sHost = sParseUri.substr(s.length(), nPos2-s.length());

                char *endptr;
                errno = 0;
                long nVal = strtol(sParseUri.substr(nPos2+1, sParseUri.length()-nPos2+1).c_str(), &endptr, 10);
                if( (ERANGE == errno && (LONG_MAX == nVal || LONG_MIN == nVal )) //underflow or overflow
                   || (errno != 0 && nVal == 0) ) //no digit
                {
                    return -1;
                }
                else
                {
                    nPort = boost::lexical_cast<std::string>(nVal);
                }
            }
            else
            {
                sHost  = sParseUri.substr(s.length(), sParseUri.length()-s.length());
                nPort = "80";
            }
        }
    }
    else if( 0 == sParseUri.compare(0, 1, "/") ) 
    {
        sPath = sParseUri;
    }
    else
    {
        return -1;
    }

    return isHttps;
}


#endif /* asyncUdpSocket_h */
